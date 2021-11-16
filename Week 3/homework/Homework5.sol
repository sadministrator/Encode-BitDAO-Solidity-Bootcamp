// SPDX-License-Identifier: UNLICENSED
// Rinkeby Address: 0xBBc6ABDc9D74c1C11C7C4F5Eb9F7517D150Ea75C
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VolcanoCoin is Ownable, ERC20 {
    struct Payment {
        address receiver;
        uint amount;
    }
    
    mapping(address => Payment[]) public payments;
    
    event supplyChange(uint);

    constructor() ERC20("VolcanoCoin", "VLCN") {
        _mint(msg.sender, 1000);
        transfer(msg.sender, 1000);
    }
    
    function increaseTotalSupply() public onlyOwner {
        _mint(owner(), 1000);
        emit supplyChange(totalSupply());
    }
    
    function createPaymentRecord(address sender, address receiver, uint amount) public {
        Payment memory payment = Payment(receiver, amount);
        payments[sender].push(payment);
    }
    
    function transferWithRecord(address receiver, uint amount) public {
        transfer(receiver, amount);
        createPaymentRecord(msg.sender, receiver, amount);
    }
}