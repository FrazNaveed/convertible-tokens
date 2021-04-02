pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract EggToken is ERC721Pausable {
    uint256 EGG_COUNTER;
    mapping (uint256 => string) EGG_COLORS;
    
    
    constructor(
        string memory name_,
        string memory symbol_
        ) ERC721(name_, symbol_) {
        EGG_COUNTER = 0;
    }
    
    function mint(address receiver, string memory color) public returns(uint256) {
        _mint(receiver, EGG_COUNTER++);
        EGG_COLORS[EGG_COUNTER] = color;
        return EGG_COUNTER;
    }
    
    function getEggColor(uint256 eggId) public view returns(string memory) {
        return EGG_COLORS[eggId];
    }
    
    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}