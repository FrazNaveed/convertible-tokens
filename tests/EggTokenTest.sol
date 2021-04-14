pragma solidity ^0.8.0;

import "../EggToken.sol";

contract EggTokenTest is EggToken {
    constructor(string memory name, string memory symbol) EggToken(name, symbol) {
        // No need for OpenZeppelin's ERC721 implementation testing
    }
}