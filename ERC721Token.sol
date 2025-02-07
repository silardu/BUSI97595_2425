// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//////////////////////////////////////////////////////
//        ArtToken Contract
//////////////////////////////////////////////////////
contract ArtToken is ERC721URIStorage, Ownable {
    uint256 private _currentTokenId;

    // Pass the initial owner to the Ownable constructor
    constructor(address initialOwner) ERC721("ArtToken", "ART") Ownable(initialOwner) {}

    function mintArtwork(address recipient, string memory tokenURI) external onlyOwner {
        _currentTokenId++;
        _safeMint(recipient, _currentTokenId);
        _setTokenURI(_currentTokenId, tokenURI);
    }
}

//////////////////////////////////////////////////////
//       HouseToken Contract
//////////////////////////////////////////////////////
contract HouseToken is ERC721URIStorage, Ownable {
    uint256 private _houseTokenId;

    // Pass the initial owner to the Ownable constructor
    constructor(address initialOwner) ERC721("HouseToken", "HSE") Ownable(initialOwner) {}

    function mintHouse(address recipient, string memory tokenURI) external onlyOwner {
        _houseTokenId++;
        _safeMint(recipient, _houseTokenId);
        _setTokenURI(_houseTokenId, tokenURI);
    }
}