// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./deps/ERC721.sol";
import "./deps/Pausable.sol";
import "./deps/IEggToken.sol";

contract EggToken is ERC721, Pausable, IEggToken {
    string[] EGG_COLORS;
    string[] EGG_VISUALS;
    string[] EGG_CLASSES;
    
    string[] CLASS_NAMES;
    uint256[][] CLASS_EGGS;
    
    uint256 MINT_COUNTER;
    mapping (uint256 => uint256) mintedEggs; // uniquId => eggId
    mapping (address => uint256[]) userBalance; // userAddress => uniqueId
    mapping (uint256 => bool) burntEggs;

    uint256 RANDOM_NONCE;

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
        MINT_COUNTER = 0;
        RANDOM_NONCE = 0;
        owner = msg.sender;
    }

    // ["orange","black","burgundy","red","blue","navy","yellow","green","cyan","purple","brown","pink","orange","skin","grey1","grey2","grey3","grey4","grey5","grey6"],["orangeVisual","blackVisual","burgundyVisual","redVisual","blueVisual","navyVisual","yellowVisual","greenVisual","cyanVisual","purpleVisual","brownVisual","pinkVisual","orangeVisual","skinVisual","grey1Visual","grey2Visual","grey3Visual","grey4Visual","grey5Visual","grey6Visual"],["A","A","B","B","B","B","B","B","B","B","B","B","B","B","C","C","C","C","C","C"]
    function setEggRewards(string[] memory colors, string[] memory visuals, string[] memory classes) external override onlyOwner {
        require(colors.length == visuals.length && visuals.length == classes.length, "EggToken::setEggRewards: Length mistmatch.");
        EGG_COLORS = colors;
        EGG_VISUALS = visuals;
        EGG_CLASSES = classes;
    }

    // ["A","B","C"],[[0,1],[2,3,4,5,6,7,8,9,10,11,12,13],[14,15,16,17,18,19]]
    function setEggClasses(string[] memory names, uint256[][] memory classEggs) external override onlyOwner {
        require(names.length == classEggs.length, "EggToken::setEggClasses: Length mismatch");
        CLASS_NAMES = names;
        CLASS_EGGS = classEggs;
    }
    
    function setFactoryOwner(address newOwner) external override onlyOwner {
        owner = newOwner;
    }
    
    function setParentFactories(address newEggFactory, address newPetFactory) external override onlyOwner {
        eggFactory = newEggFactory;
        petFactory = newPetFactory;
    }

    function getEggRewards() external view override returns(string[] memory colors, string[] memory visuals, string[] memory classes) {
        colors = EGG_COLORS;
        visuals = EGG_VISUALS;
        classes = EGG_CLASSES;
    }

    function getEggClasses() external view override returns(string[] memory names, uint256[][] memory eggsPerClass) {
        names = CLASS_NAMES;
        eggsPerClass = CLASS_EGGS;
    }

    function getEggFromId(uint256 eggId) external view override returns(string memory color, string memory visual, string memory class) {
        color = EGG_COLORS[eggId];
        visual = EGG_VISUALS[eggId];
        class = EGG_CLASSES[eggId];
    }

    function getEggFromMintedId(uint256 mintedId) external view override returns(string memory color, string memory visual, string memory class) {
        uint256 eggId = mintedEggs[mintedId];
        color = burntEggs[mintedId] ? "BURNT" : EGG_COLORS[eggId];
        visual = burntEggs[mintedId] ? "BURNT" : EGG_VISUALS[eggId];
        class = burntEggs[mintedId] ? "BURNT" : EGG_CLASSES[eggId];
    }

    function getOwners() external view override returns(address _owner, address _eggFactory, address _petFactory) {
        _owner = owner;
        _eggFactory = eggFactory;
        _petFactory = petFactory;
    }

    function getUserEggs(address user) external view override returns(uint256[] memory mintedIds) {
        mintedIds = userBalance[user];
    }

    function mintRandom(address receiver, uint256 class) external override onlyOwner returns(uint256 mintedId) {
        RANDOM_NONCE = (RANDOM_NONCE + 1) % 1000000000;
        uint256 randomEggFromClass = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, RANDOM_NONCE))) % (CLASS_EGGS[class].length);
        _mint(receiver, MINT_COUNTER);
        mintedEggs[MINT_COUNTER] = CLASS_EGGS[class][randomEggFromClass];
        userBalance[receiver].push(MINT_COUNTER);
        mintedId = MINT_COUNTER++;
    }

    function burn(uint256 tokenId) external override onlyOwner {
        burntEggs[tokenId] = true;
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        require(!paused(), "ERC721Pausable: token transfer while paused");
    }

    function pause() external override onlyOwner {
        _pause();
    }
    
    function unpause() external override onlyOwner {
        _unpause();
    }
}