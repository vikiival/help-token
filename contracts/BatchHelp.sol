// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HelpToken is ERC1155, Ownable {
    uint16 private constant _totalSupply = 10000; // 10,000 tokens
    uint16 public alreadyMinted = 0; // 10,000 tokens
    uint public constant tokenValue = 1e16 wei; // 0.01 ether
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_)
        ERC1155("https://ipfs.io/ipfs/QmY55mvuwrSdHhZisdH82Unp4HKzzBFdEHFnw8AuLGQNum")
    {
        _name = name_;
        _symbol = symbol_;
    }

    function create(uint16 count) external payable {
        require(count  <= _totalSupply - alreadyMinted, "No tokens available");
        require(msg.value >= tokenValue * count, "Not enough ETH sent");
        mint(msg.sender, 0, count);
        alreadyMinted += count;
        address payable destination = payable(owner());
        destination.transfer(msg.value);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function mint(address account, uint256 id, uint256 amount)
        private
    {
        _mint(account, id, amount, "");
    }
}

