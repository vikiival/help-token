// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
    uint16 private constant _totalSupply = 10000; // 10,000 tokens
    uint16 public alreadyMinted = 0; // 10,000 tokens
    uint public constant tokenValue = 1e16 wei; // 0.01 ether
    constructor()
        ERC1155("https://ipfs.io/ipfs/QmY55mvuwrSdHhZisdH82Unp4HKzzBFdEHFnw8AuLGQNum")
    {}

    function create(uint16 count) public payable {
        require(count  <= _totalSupply - alreadyMinted, "Not enough fee tokens");
        require(msg.value >= tokenValue * count, "Not enough ETH sent");
        mint(msg.sender, 0, count);
        alreadyMinted += count;
        address payable destination = payable(owner());
        destination.transfer(msg.value);
    }


    function mint(address account, uint256 id, uint256 amount)
        private
    {
        _mint(account, id, amount, "");
    }
}
