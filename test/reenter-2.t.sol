// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../src/reenter-2.sol";
import "../src/renter-2-attacker.sol";

contract exploit is Test{

    VulnerableBank public bank;
    Attacker public attackerContract;
    address user = makeAddr("user");


    function setUp() public{
        bank = new VulnerableBank();
        attackerContract = new Attacker(address(bank));
        vm.deal(address(bank), 100 ether);
        vm.deal(address(attackerContract), 50 ether);

        vm.deal(user, 10 ether);

    }

  function testExpoit() external{

        vm.startPrank(address(attackerContract));
        attackerContract.attack{value: 50 ether}();
        assert(address(bank).balance == 0);
        console.log(address(attackerContract).balance);
        vm.stopPrank();

    }
    function testWithdraw()external{
        vm.startPrank(user);
        bank.deposit{value: 10 ether}();
        console.log(user.balance);
        console.log(address(bank).balance);
        bank.withdraw();
        console.log(user.balance);
        console.log(address(bank).balance);
        vm.stopPrank();

    }
  
}
