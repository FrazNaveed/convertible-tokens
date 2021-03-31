pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract EggToken is ERC721 {
    uint256 EGG_COUNTER;
    mapping (uint256 => string) EGG_COLORS;
    
    
    constructor() ERC721("Egg Token", "ETK") {
        EGG_COUNTER = 0;
    }
    
    function mint(address receiver, string memory color) public {
        _mint(receiver, EGG_COUNTER++);
        EGG_COLORS[EGG_COUNTER] = color;
    }
}