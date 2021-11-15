// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VolcanoCoin {
    struct Payment {
        uint amount;
        address receiver;
    }
    
    address public owner;
    uint public totalSupply;
    mapping(address => uint) public balance;
    mapping(address => Payment[]) public payments;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    event supplyChange(uint);
    event transferEvent(uint, address);
    
    constructor() {
        owner = msg.sender;
        totalSupply = 1000;
        balance[owner] = totalSupply;
    }
    
    function getSupply() public view returns (uint) {
        return totalSupply;
    }
    
    function increaseTotalSupply() public onlyOwner {
        totalSupply += 1000;
        emit supplyChange(totalSupply);
    }
    
    function balanceOf(address _user) public view returns (uint) {
        return balance[_user];
    }
    
    function transfer(uint _amount, address _receiver) public {
        require(balance[msg.sender] > _amount);
        
        balance[msg.sender] -= _amount;
        balance[_receiver] += _amount;
        
        Payment memory payment = Payment(_amount, _receiver);
        payments[msg.sender].push(payment);
        emit transferEvent(_amount, _receiver);
    }
}