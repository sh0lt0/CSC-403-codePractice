pragma solidity ^0.8.20;

contract File{

    mapping(address => uint256) public  balances;//0 // mapping 0xa > balance

    uint public x = 0 ;

    function test() public returns(uint){
      // return  x--; // x = x -1  > 0 -1 = max(uint256)
        // underflow
    }

    function test1() public returns(uint){
       unchecked{
       return  x--; 
    }
    }
    //token minting, x = 0;
    // vault = 0 token
    // val = x -1;
 //   max(uint256) 


   /* function transfer(address _to, uint256 value) public  {
        require(balances[msg.sender] >= value); // balance = 100 , val = 20

        balances[msg.sender] -= value; // bal =100 , bal = bal -val =80
        balances[_to] +=value; // rec.bal = rec.bal + val = 10 + 20 = 30

      //  bal.msg.sender = 10
       // val = -11
        // val sent != -1 but max of int256


       

    }*/
}
