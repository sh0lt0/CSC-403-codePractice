// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20; //version for solidity used


contract VulnerableBank { //contract name
mapping(address => uint) public balances; //store balance against addresses

function deposit() public payable { //allow user to send ETH to contract
balances[msg.sender] += msg.value; //increases sender(msg.sender) balance by amount sent
}

function withdraw(uint _amount) public { //to withdraw
require(balances[msg.sender] >= _amount); //check user must have enough balance

(bool sent, ) = msg.sender.call{value: _amount}(""); //sends ETH to msg.sender and return true if successful..where .call is an external call
require(sent, "Failed"); //if true transaction is sent, false it failed

balances[msg.sender] -= _amount; //updating balance
}
}
