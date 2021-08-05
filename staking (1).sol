// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

contract ERCToken
{
    function totalSupply() external view returns (uint256){}

    function balanceOf(address who) external view returns (uint256){}

    function allowance(address owner, address spender)
    external view returns (uint256){}

    function transfer(address to, uint256 value) external returns (bool){}

    function approve(address spender, uint256 value)
    external returns (bool){}

    function transferFrom(address from, address to, uint256 value)
    external returns (bool){}

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Coruls_stack{
    ERCToken dc;
 
    uint256 public threeMonths = 6; uint256 public sixMonths = 12; uint256 public twelveMonths = 15; address public Owner;
    struct StakeHolder { uint256 balance; uint256 start_date; uint256 duration; uint256 finalAmount; }
    
    mapping(address => StakeHolder) public myStake;
    mapping(uint=>StakeHolder) public _rand;
    
    function random() private view returns (uint) {
    uint rand =  uint(keccak256(abi.encodePacked(
        block.difficulty,
        now,
        msg.sender) ));
        return rand;
} 
    
 constructor() public {
        Owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == Owner, "only admin can run this function");
        _;
    }
    
    function stakeHolder(address investers, uint256 time) public payable returns(bool) {
        // myStake[investers] = StakeHolder(amount,block.timestamp,time); 
        
        uint256 temp;
        
        if(time == 20 )
        {
            temp = msg.value+msg.value * threeMonths/100;
            myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
        } else if(time == 40 ) {
            
            temp = msg.value+msg.value * sixMonths/100; 
            myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
            
        } else if(time == 60 ) {
            
            temp = msg.value+msg.value * twelveMonths/100; 
             myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
        }
        
       return true;
    }
    
      function Existing(address _t) public {
        dc = ERCToken(_t);
    }
    
    function manualWithdraw() external{

    
        if(block.timestamp < myStake[msg.sender].duration) {
        
            dc.transfer(msg.sender,myStake[msg.sender].balance);
         // payable(msg.sender).transfer(myStake[msg.sender].balance);
            //myStake[msg.sender].balance = 0;
            delete myStake[msg.sender];
           
        } 
        else if(block.timestamp > myStake[msg.sender].duration) {
            dc.transfer(msg.sender,myStake[msg.sender].finalAmount);
            delete myStake[msg.sender];
          // payable(msg.sender).transfer(myStake[msg.sender].finalAmount);
          // myStake[msg.sender].finalAmount=0;
          } 
          else {
            revert("First invest your token in the stake."); 
        }
        
    }
    
    function ownerWithdraw(uint256 amount) onlyOwner external returns(bool success){ 
     payable(msg.sender).transfer(amount);
        
       return true;
    }
    
    function OwnerTokenWithdraw(address _addr,uint256 value) onlyOwner external returns(bool success){
       dc.transfer(_addr,value);
       return(true);
    }
   
    function balanceOf()  public view returns(uint256 balance){
        return address(this).balance;
    }
    
    function ChangeThreeMonthsInterestRate( uint256 percentage) onlyOwner public{
        threeMonths = percentage; 
    }
    function ChangeSixMonthsInterestRate( uint256 percentage) onlyOwner public {
        sixMonths = percentage;
    }
    
    function ChangeTwelveMonthsInterestRate( uint256 percentage) onlyOwner public  {
        twelveMonths = percentage;
    
    }
}
