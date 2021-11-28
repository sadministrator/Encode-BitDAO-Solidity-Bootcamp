// SPDX-License-Identifier: UNLICENSED
// Rinkeby Address: 0xB770DFc9629c04FA3aFce825ca96D4245fF2A053
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VolcanoCoin is Ownable, ERC20 {
    struct Payment {
        address recipient;
        uint amount;
    }
    
    mapping(address => Payment[]) public payments;
    
    event supplyChange(uint);

    constructor() ERC20("VolcanoCoin", "VLCN") {
        _mint(msg.sender, 1000 * (10 ** uint(decimals())));
        transfer(msg.sender, 1000 ether);
    }
    
    function increaseTotalSupply() public onlyOwner {
        _mint(owner(), 1000);
        emit supplyChange(totalSupply());
    }

    function transfer(address recipient, uint256 amount) public override returns (bool){
        Payment memory payment = Payment(recipient, amount);
        payments[msg.sender].push(payment);

        return super.transfer(recipient, amount);
    }
}