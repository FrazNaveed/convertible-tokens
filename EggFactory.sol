pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./EggLootBox.sol";
import "./EggToken.sol";

contract EggFactory {
    address CANDY_ERC20;
    uint256 LOOTBOX_OPTIONS;
    uint256[] LOOTBOX_PRICES;
    uint256[][] LOOTBOX_PROBABILITIES;
    uint256 EGG_OPTIONS;
    uint256 EGG_CLASSES;
    string[] CLASS_COLORS;
    EggLootBox LOOTBOX;
    EggToken EGG_TOKEN;
    
    address factoryOwner;
    
    event EggLootBoxOpened(address opener, string mintedClass);
    
    constructor(
            address rewardingAddress,
            uint256 lootBoxOptions,
            uint256[] memory lootBoxPrices,
            uint256[][] memory lootBoxProbabilities,
            uint256 eggOptions,
            uint256 eggClasses,
            string[] memory classColors
        ) {
        CANDY_ERC20 = rewardingAddress;
        LOOTBOX_OPTIONS = lootBoxOptions;
        LOOTBOX_PRICES = lootBoxPrices;
        LOOTBOX_PROBABILITIES = lootBoxProbabilities;
        EGG_OPTIONS = eggOptions;
        EGG_CLASSES = eggClasses;
        CLASS_COLORS = classColors;
        LOOTBOX = new EggLootBox(LOOTBOX_OPTIONS, EGG_OPTIONS, EGG_CLASSES);
        
        for(uint i = 0; i < LOOTBOX_OPTIONS; i++) {
            LOOTBOX.setEggOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
        
        EGG_TOKEN = new EggToken();
        
        factoryOwner = msg.sender;
    }
    
    function setFactoryState(
            address rewardingAddress,
            uint256 lootBoxOptions,
            uint256[] memory lootBoxPrices,
            uint256[][] memory lootBoxProbabilities,
            uint256 eggOptions,
            uint256 eggClasses,
            string[] memory classColors
        ) external {
        require(msg.sender == factoryOwner, "EggFactory::setFactoryState: Only owner can perform this operation");
        CANDY_ERC20 = rewardingAddress;
        LOOTBOX_OPTIONS = lootBoxOptions;
        LOOTBOX_PRICES = lootBoxPrices;
        LOOTBOX_PROBABILITIES = lootBoxProbabilities;
        EGG_OPTIONS = eggOptions;
        EGG_CLASSES = eggClasses;
        CLASS_COLORS = classColors;
        
        LOOTBOX.setEggLootBoxState(LOOTBOX_OPTIONS, EGG_OPTIONS, EGG_CLASSES);
        
        for(uint i = 0; i < LOOTBOX_OPTIONS; i++) {
            LOOTBOX.setEggOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
    }
    
    function getFactoryState() external view returns (
            address,
            uint256,
            uint256[] memory,
            uint256[][] memory,
            uint256,
            uint256,
            string[] memory
        ) {
        return (
            CANDY_ERC20,
            LOOTBOX_OPTIONS,
            LOOTBOX_PRICES,
            LOOTBOX_PROBABILITIES,
            EGG_OPTIONS,
            EGG_CLASSES,
            CLASS_COLORS
        );
    }
    
    function transferFactoryOwnership(address newOwner) external {
        require(msg.sender == factoryOwner, "EggFactory::transferFactoryOwnership: Only owner can perform this operation");
        factoryOwner = newOwner;
    }
    
    function buyLootBox(uint256 selectedOption) external {
        ERC20 CandyToken = ERC20(CANDY_ERC20);
        require(CandyToken.balanceOf(msg.sender) >= LOOTBOX_PRICES[selectedOption], "EggFactory::buyLootBox: User does not have sufficient Candies");
        
        uint256 returnedClass = LOOTBOX.mintAndOpen(selectedOption);
        //CandyToken._burn(msg.sender, LOOTBOX_PRICES[selectedOption]);
        
        EGG_TOKEN.mint(msg.sender, CLASS_COLORS[returnedClass]);
        
        emit EggLootBoxOpened(msg.sender, CLASS_COLORS[returnedClass]);
    }
}