// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VolcanoToken is Ownable, ERC721 {
    using Counters for Counters.Counter;
    
    struct Metadata {
        uint256 id;
        uint256 timestamp;
        string tokenURI;
    }
    
    Counters.Counter private _tokenIds;

    mapping(address => Metadata[]) private _balances;
    
    constructor() ERC721("VolcanoToken", "VLCNTKN") {
        
    }

    function mint(address recipient) public onlyOwner {
        _tokenIds.increment();

        uint256 newId = _tokenIds.current();
        string memory newURI = "uri";
        Metadata memory token = Metadata(newId, block.timestamp, newURI);

        _mint(recipient, newId);

        _balances[recipient][newId] = token;
    }
    
    function _removeTokenFromBalance(uint256 id) internal returns (bool) {
        Metadata[] memory balance = _balances[msg.sender];

        for(uint256 i = 0; i < balance.length; i++) {
            if(balance[i].id == id) {
                delete balance[i];
                return true;
            }
        }
        return false;
    }
    
    function burn(uint256 id) public {
        address sender = msg.sender;
        require(_balances[sender][id].id == id);
        
        _burn(id);
        _removeTokenFromBalance(id);
    }
    
    function getURI(uint256 id) public returns (string memory) {
        return tokenURI(id);
    }
}