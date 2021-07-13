// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

contract Coruls_stack{
 
    uint256 public threeMonths = 6; uint256 public sixMonths = 12; uint256 public twelveMonths = 15; address public Owner;
    struct StakeHolder { uint256 balance; uint256 start_date; uint256 duration; uint256 finalAmount; }
    
    mapping(address=>StakeHolder) public myStake;   
    constructor() public {
        
        Owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == Owner, "only admin can run this function"); _;
    }
    
    function stakeHolder(address investers, uint256 time) public payable returns(bool) {
        // myStake[investers] = StakeHolder(amount,block.timestamp,time); 
        
        uint256 temp;
        
        if(time == 20 )
        {
            temp =msg.value+msg.value*threeMonths/100;
            myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
        } else if(time == 40 ) {
            
            temp =msg.value+msg.value * sixMonths/100; 
            myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
            
        } else if(time == 60 ) {
            
            temp = msg.value+msg.value * twelveMonths/100; 
             myStake[investers] = StakeHolder(msg.value, block.timestamp,block.timestamp+time,temp);
        }
        
       return true;
    }
    
    function manualWithdraw() external{
    
        if(block.timestamp < myStake[msg.sender].duration) {
           payable(msg.sender).transfer(myStake[msg.sender].balance);
            myStake[msg.sender].balance = 0;
           
        } 
        else if(block.timestamp > myStake[msg.sender].duration) {
           payable(msg.sender).transfer(myStake[msg.sender].finalAmount);
           myStake[msg.sender].finalAmount=0;
            
        }  else {
            revert("First invest your token in the stake."); 
        }
        
    }
    
    function ownerWithdraw(uint256 amount) onlyOwner external returns(bool success){ 
       msg.sender.transfer(amount);
        
       return true;
    }
    function balanceOf()  public view returns(uint256 balance){
        return address(this).balance;
    }
    
    function ChangeThreeMonthsInterestRate( uint256 percentage) onlyOwner public returns(uint256){
        threeMonths = percentage; 
    }
    function ChangeSixMonthsInterestRate( uint256 percentage) onlyOwner public returns(uint256){
        sixMonths = percentage;
    }
    
    function ChangeTwelveMonthsInterestRate( uint256 percentage) onlyOwner public returns(uint256){
        twelveMonths = percentage;
    
    }
}