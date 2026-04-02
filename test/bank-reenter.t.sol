//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/bc.sol";
import "../src/attacker.sol";

contract ReentrancyTest is Test {
VulnerableBank public bank;
attacker public attack1;

function setUp() public{
bank = new VulnerableBank();
attack1 = new attacker(address(bank));

vm.deal(address(bank), 10 ether);
vm.deal(address(attack1), 10 ether);
}

function testExploit() public{
vm.startPrank(address(attack1));
attack1.attack{value: 1 ether}();

assert(address(bank).balance==0);
vm.stopPrank();
}

}
