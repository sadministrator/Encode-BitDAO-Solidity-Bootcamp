// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract VolcanoToken is Ownable, ERC721 {
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    struct Metadata {
        uint256 id;
        uint256 timestamp;
        string tokenURI;
    }
    string private constant _BASEURI = "https://ipfs.org/";
    Counters.Counter private _tokenIds;

    mapping(address => Metadata[]) private _balances;
    
    constructor() ERC721("VolcanoToken", "VLCNTKN") {}

    function mint(address recipient) public onlyOwner {
        _tokenIds.increment();

        uint256 newId = _tokenIds.current();
        string memory newURI = string(abi.encodePacked(_BASEURI, newId.toString()));
        Metadata memory token = Metadata(newId, block.timestamp, newURI);

        _mint(recipient, newId);

        _balances[recipient].push(token);
    }
    
    function _removeTokenFromBalance(uint256 id) internal returns (bool) {
        Metadata[] storage balance = _balances[msg.sender];

        for(uint256 i = 0; i < balance.length; i++) {
            if(balance[i].id == id) {
                balance[i] = balance[balance.length];
                _balances[msg.sender].pop();
                return true;
            }
        }
        return false;
    }

    function transfer(address recipient, uint256 id) public {
        transferFrom(msg.sender, recipient, id);
        _removeTokenFromBalance(id);
        _balances[recipient].push(Metadata(id, block.timestamp, tokenURI(id)));
    }
    
    function burn(uint256 id) public {
        require(_balances[msg.sender][id].id == id);
        
        _burn(id);
        _removeTokenFromBalance(id);
    }

    function tokensOf(address owner) public view returns (Metadata[] memory) {
        return _balances[owner];
    }
}