// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vault {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public rewards;

    function deposit() external payable {
        balances[msg.sender] += msg.value; //caller balance = caller bal + amount deposited
    }

    function addReward(address user, uint256 amount) external {
        rewards[user] += amount;
    }

    function claimReward() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No reward");

        (bool success, ) = msg.sender.call{value: reward}(""); // external call
        require(success, "Transfer failed");

        rewards[msg.sender] = 0; //state update after external call
    }

    function withdrawAll() external {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No balance");

        (bool success, ) = msg.sender.call{value: bal}(""); // external call
        require(success, "Transfer failed");

        balances[msg.sender] = 0; //state update after external call
    }

    receive() external payable {}
}
/*
[CRITICAL]

Step 1:
Attacker deposits ETH and gets rewards assigned.

Step 2:
Attacker calls claimReward()

Step 3:
During external call in claimReward(), control is transferred to attacker while:
- rewards[attacker] is NOT reset
- balances[attacker] is still intact

Step 4:
Attacker reenters withdrawAll() and withdraws full balance

Step 5:
During withdrawAll() external call, attacker reenters claimReward() again

Step 6:
Since rewards are still not reset, attacker claims reward multiple times

Result:
Attacker repeatedly extracts both rewards and deposited balance before state is updated, draining the contract.

Root Cause:
Cross-function reentrancy due to state updates occurring after external calls in both claimReward() and withdrawAll()
*/
