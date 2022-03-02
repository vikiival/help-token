// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HelpToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint16 private _totalSupply = 10000; // 10,000 tokens
    uint public tokenValue = 1e16 wei; // 0.01 ether

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/QmY55mvuwrSdHhZisdH82Unp4HKzzBFdEHFnw8AuLGQNum";
    }

    function create(uint16 count) public payable {
        require(count <= _totalSupply - _tokenIdCounter.current(), "Not enough fee tokens");
        require(msg.value >= tokenValue * count, "Wrong token value");

        for (uint16 i = 0; i < count; i++) {
            safeMint(msg.sender);
        }
        
        address payable destination = payable(owner());
        destination.transfer(msg.value);
    }

    function totalSupply() public view returns (uint16) {
        return _totalSupply;
    }

    function safeMint(address to) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

        // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return _baseURI();
    }
}
