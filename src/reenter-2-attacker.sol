pragma solidity ^0.8.20;

import "./reenter-2.sol";

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



