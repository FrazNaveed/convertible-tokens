pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./EggLootBox.sol";
import "./EggToken.sol";

contract EggFactory {
    address SOURCE_TOKEN;
    uint256 LOOTBOX_OPTIONS;
    uint256[] LOOTBOX_PRICES;
    uint256[][] LOOTBOX_PROBABILITIES;
    uint256 EGG_OPTIONS;
    string[] EGG_COLORS;
    uint256 EGG_CLASSES;
    string[] CLASS_NAMES;
    string[][] CLASS_EGGS;
    string EGG_TOKEN_NAME;
    string EGG_TOKEN_SYMBOL;
    uint256 RANDOM_NONCE;
    EggLootBox LOOTBOX;
    EggToken EGG_TOKEN;
    
    address factoryOwner;
    address delegatedOwner;
    
    event EggLootBoxOpened(address opener, string mintedClass, string mintedEgg);
    
    modifier onlyOwner() {
        require(msg.sender == factoryOwner, "EggFactory: Only owner can perform this action.");
        _;
    }
    
    modifier onlyDelegatedOwner() {
        require(msg.sender == factoryOwner || msg.sender == delegatedOwner, "EggFactory: Only owner or delegated owner can perform this action");
        _;
    }
    
    constructor(
            address sourceTokenAddress,
            uint256 lootBoxOptions,
            uint256[] memory lootBoxPrices,
            uint256[][] memory lootBoxProbabilities,
            uint256 eggOptions,
            string[] memory eggColors,
            uint256 eggClasses,
            string[] memory classNames,
            string[][] memory classEggs,
            string memory eggTokenName,
            string memory eggTokenSymbol
        ) {
        SOURCE_TOKEN = sourceTokenAddress;
        LOOTBOX_OPTIONS = lootBoxOptions;
        LOOTBOX_PRICES = lootBoxPrices;
        LOOTBOX_PROBABILITIES = lootBoxProbabilities;
        EGG_OPTIONS = eggOptions;
        EGG_COLORS = eggColors;
        EGG_CLASSES = eggClasses;
        CLASS_NAMES = classNames;
        CLASS_EGGS = classEggs;
        LOOTBOX = new EggLootBox(LOOTBOX_OPTIONS, EGG_CLASSES);
        
        for(uint i = 0; i < LOOTBOX_OPTIONS; i++) {
            LOOTBOX.setEggOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
        
        EGG_TOKEN = new EggToken(eggTokenName, eggTokenSymbol);
        
        factoryOwner = msg.sender;
        
        RANDOM_NONCE = 0;
    }
    
    function setSourceTokenAddress(address newAddess) external onlyDelegatedOwner {
        SOURCE_TOKEN = newAddess;
    }
    
    function setLootBoxOptions(uint256 newOptions, uint256[] memory newPrices) external onlyDelegatedOwner {
        LOOTBOX_OPTIONS = newOptions;
        LOOTBOX_PRICES = newPrices;
    }
    
    function setLootBoxProbabilities(uint256[][] memory newProbabilities) external onlyDelegatedOwner {
        LOOTBOX_PROBABILITIES = newProbabilities;
    }
    
    function setEggOptions(uint256 newOptions, string[] memory newColors) external onlyDelegatedOwner {
        EGG_OPTIONS = newOptions;
        EGG_COLORS = newColors;
    }
    
    function setEggClasses(uint256 newClasses, string[] memory newClassNames, string[][] memory newClassEggs) external onlyDelegatedOwner {
        EGG_CLASSES = newClasses;
        CLASS_NAMES = newClassNames;
        CLASS_EGGS = newClassEggs;
    }
    
    function refreshLootBox() external onlyDelegatedOwner {
        LOOTBOX.setEggLootBoxState(LOOTBOX_OPTIONS, EGG_CLASSES);
        for (uint i = 0; i < LOOTBOX_OPTIONS; i++) {
            LOOTBOX.setEggOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
    }
    
    function setDelegatedOwner(address newDelegate) external onlyOwner {
        delegatedOwner = newDelegate;
    }
    
    function transferFactoryOwnership(address newOwner) external onlyOwner {
        factoryOwner = newOwner;
    }

    function getSourceToken() view external returns(address) {
        return SOURCE_TOKEN;
    }
    
    function getLootBoxOptions() view external returns(uint256, uint256[] memory) {
        return (LOOTBOX_OPTIONS, LOOTBOX_PRICES);
    }
    
    function getLootBoxProbabilities() view external returns(uint256[][] memory) {
        return LOOTBOX_PROBABILITIES;
    }
    
    function getEggOptions() view external returns(uint256, string[] memory) {
        return (EGG_OPTIONS, EGG_COLORS);
    }
    
    function getEggClasses() view external returns(uint256, string[] memory, string[][] memory) {
        return (EGG_CLASSES, CLASS_NAMES, CLASS_EGGS);
    }
    
    function getDeployedLootBox() view external returns(address) {
        return address(LOOTBOX);
    }
    
    function getDeployedEggToken() view external returns(address) {
        return address(EGG_TOKEN);
    }
    
    function getFactoryOwner() view external returns(address) {
        return factoryOwner;
    }
    
    function getDelegatedOwner() view external returns(address) {
        return delegatedOwner;
    }
    
    function buyLootBox(uint256 selectedClass) external returns(address, string memory, string memory) {
        ERC20 SourceToken = ERC20(SOURCE_TOKEN);
        require(SourceToken.balanceOf(msg.sender) >= LOOTBOX_PRICES[selectedClass], "EggFactory::buyLootBox: User does not have sufficient source tokens");
        
        SourceToken.transferFrom(msg.sender, address(this), LOOTBOX_PRICES[selectedClass]);
        
        uint256 returnedClass = LOOTBOX.mintAndOpen(selectedClass);

        uint256 randomEggFromClass = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, RANDOM_NONCE++))) % (CLASS_EGGS[returnedClass].length);

        EGG_TOKEN.mint(msg.sender, EGG_COLORS[randomEggFromClass]);
        
        return(msg.sender, CLASS_NAMES[returnedClass], CLASS_EGGS[returnedClass][randomEggFromClass]);
        
        emit EggLootBoxOpened(msg.sender, CLASS_NAMES[returnedClass], CLASS_EGGS[returnedClass][randomEggFromClass]);
    }
}