// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VolcanoCoin {
    address public owner;
    uint public totalSupply;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    event supplyChange(uint);
    
    constructor() {
        owner = msg.sender;
        totalSupply = 1000;
    }
    
    function getSupply() public returns (uint) {
        return totalSupply;
    }
    
    function increaseTotalSupply() public onlyOwner {
        totalSupply += 1000;
        emit supplyChange(totalSupply);
    }
}