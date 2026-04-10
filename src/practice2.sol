
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

function withdraw() external {
     
    uint256 amount = balances[msg.sender];
    require(amount > 0, "Nothing to withdraw");

    (bool success, ) = msg.sender.call{value: amount}(""); // this gives control to the attacker and if it is a contract, it can code a fallback to call withdraw() again before state change
    
    require(success, "Transfer failed");

    balances[msg.sender] = 0;
}

function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}


/*
[CRITICAL]

Step 1:
Attacker deposits 1 ETH
→ balances[attacker] = 1 ETH

Step 2:
Attacker calls withdraw()

Step 3:
Contract reads:
amount = balances[attacker] = 1 ETH

Step 4:
Contract sends ETH via:
msg.sender.call{value: amount}()

→ Control transfers to attacker contract

Step 5:
IMPORTANT:
balances[attacker] is STILL 1 ETH (not updated yet)

Step 6:
Attacker reenters withdraw() from fallback

Step 7:
Contract again reads:
amount = balances[attacker] = 1 ETH

Step 8:
Process repeats → multiple withdrawals

Step 9:
After recursion ends:
balances[attacker] is finally set to 0

Result:
Attacker withdraws multiple times using same balance
→ drains entire contract
*/
