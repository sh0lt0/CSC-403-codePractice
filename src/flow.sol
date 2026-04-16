pragma solidity ^0.6.0;

contract File{

    mapping(address => uint256) public  balances;

    function transfer(address _to, uint256 value) public {
        require(balances[msg.sender] >= value);

        balances[msg.sender] -= value;
        balances[_to] +=value;
    }
}
