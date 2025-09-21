// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import "@ganache/console.log/console.sol";

contract Spacebear is ERC721, Ownable {
    
    uint256 private _nextTokenId;


    constructor(address initialOwner)
        ERC721("Spacebear", "SBR")
        Ownable(initialOwner)
    {}


    function _baseURI() internal pure override returns (string memory) {
        return "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/";
    }


    function safeMint(address to)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }

 
    function buyToken() public payable {
        uint256 tokenId = _nextTokenId;
        console.log("got here", tokenId, msg.value);
        require(msg.value == (tokenId + 1) * 0.1 ether, "Not enough funds sent");

        _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }
    
    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721)
        returns (string memory)
    {

        return string(abi.encodePacked(_baseURI(), "spacebear_", (tokenId +1), ".json"));
    }
}