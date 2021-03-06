pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract EggToken is ERC721Pausable {
    uint256 EGG_COUNTER;
    mapping (uint256 => string) EGG_COLORS;
    mapping (uint256 => string) EGG_VISUALS;
    
    address owner;
    address eggFactory;
    address petFactory;
    
    modifier onlyOwner() {
        require(msg.sender == owner || msg.sender == eggFactory || msg.sender == petFactory, "EggToken: This action can only be performed by owner or EggFactory");
        _;
    }
    
    constructor(
        string memory name_,
        string memory symbol_
        ) ERC721(name_, symbol_) {
        EGG_COUNTER = 0;
        owner = msg.sender;
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    function setParentFactories(address newEggFactory, address newPetFactory) external onlyOwner {
        eggFactory = newEggFactory;
        petFactory = newPetFactory;
    }
    
    function getOwners() external view returns(address, address, address) {
        return(owner, eggFactory, petFactory);
    }
    
    function getEggColor(uint256 eggId) external view returns(string memory) {
        return EGG_COLORS[eggId];
    }
    
    function getEggVisual(uint256 eggId) external view returns(string memory) {
        return EGG_VISUALS[eggId];
    }
    
    function mint(address receiver, string memory color, string memory visual) external onlyOwner returns(uint256) {
        _mint(receiver, ++EGG_COUNTER);
        EGG_COLORS[EGG_COUNTER] = color;
        EGG_VISUALS[EGG_COUNTER] = visual;
        return EGG_COUNTER;
    }
    
    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
        delete EGG_COLORS[tokenId];
        delete EGG_VISUALS[tokenId];
    }
    
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
}