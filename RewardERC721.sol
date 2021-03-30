pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol';

contract RewardERC721 is ERC721 {
    uint256 TOKEN_COUNTER;                          // Maximum number of tokens that can be generated: 2²⁵⁶–1
    mapping (uint256 => uint256) ASSIGNED_TOKENS;   // Mapping of token id to assigned token number
                                                    // Token number is a number between 0 - 3 representing color
    
    constructor (string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        TOKEN_COUNTER = 0;
    }
    
    function mint(address to, uint256 option) public returns(uint256) {
        ASSIGNED_TOKENS[TOKEN_COUNTER++] = option;
        _mint(to, TOKEN_COUNTER);
        return TOKEN_COUNTER;
    }
     
    function getTokenColor(uint256 tokenId) public view returns(string memory) { // Gets the color name against color number
        uint256 colorNumber = ASSIGNED_TOKENS[tokenId];
        return  colorNumber == 0 ? "BLUE" :
                colorNumber == 1 ? "GREEN" :
                colorNumber == 2 ? "RED" :
                "ORANGE";
    }
}