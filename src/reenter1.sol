// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStaking {
    mapping(address => uint256) public balances;
    uint256 public totalStaked;
    uint256 public rewardRate = 1; // 1 token per second

    mapping(address => uint256) public lastUpdate;//@danger

/* Attack path
   Become a user by staking a very small amount > stake()
   Let time pass as more time elapsed more the reward
   Claim the reward > claimRewards()
*/
    function stake() external payable {
        require(msg.value > 0, "Zero stake");

        _updateRewards(msg.sender);

        balances[msg.sender] += msg.value;//@danger
        totalStaked += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough");

        _updateRewards(msg.sender);

        balances[msg.sender] -= amount;
        totalStaked -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");//@external
        require(success, "Transfer failed");
    }

    function claimRewards() external {
        uint256 reward = _calculateRewards(msg.sender);
        require(reward > 0, "No rewards");

        lastUpdate[msg.sender] = block.timestamp;

        (bool success, ) = msg.sender.call{value: reward}("");//@external
        require(success, "Reward transfer failed");
    }

    function _updateRewards(address user) internal {
        uint256 reward = _calculateRewards(user);
        lastUpdate[user] = block.timestamp;//@danger

        if (reward > 0) {
            (bool success, ) = user.call{value: reward}("");//@external > can be called by external functions so unsafe
            require(success, "Reward failed");
        }
    }

    function _calculateRewards(address user) internal view returns (uint256) {
        uint256 timeElapsed = block.timestamp - lastUpdate[user]; //@audit-issue - > uninitialised lastUpdate(first time it will be zero)
        return timeElapsed * rewardRate * balances[user]; // 1. No capping on reward
                                                          // 2. Controlled by user 
    }

    receive() external payable {} //@no balance update after receiving ether
}

/* 
Where does money enter? > stake(), payable()

Where does money leave? > withdraw(), _updateRewards, claimRewards()

What controls reward calculation? > timeElapsed, rewardRate, balances[user]

What assumptions does this contract make?
 */
