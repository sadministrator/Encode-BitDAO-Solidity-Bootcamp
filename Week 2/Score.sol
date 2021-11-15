// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Score {
    uint score;
    address owner;
    
    modifier onlyOwner() {
        if(msg.sender == owner) {
            _;
        }
    }
    
    event ScoreSet (uint);
    
    constructor() {
        score = 5;
        owner = msg.sender;
    }
    
    function getScore() public view returns (uint) {
        return score;
    }
    
    function setScore(uint _score) public  onlyOwner{
        score = _score;
        emit ScoreSet(_score);
    }
}