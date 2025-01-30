// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./ERC20.sol";

contract myFirstToken is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
    {
        // Mint 100 tokens to msg.sender
        // 1 token = 1 * (10 ** decimals)
        _mint(msg.sender, 100 * 10 ** uint256(decimals));
    }
}