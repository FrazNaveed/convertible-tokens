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
    
    constructor() {
        CANDY_ERC20 = 0x1963E04a845213d005cDf0e22a39F85BD5941390;
        LOOTBOX_OPTIONS = 4;
        LOOTBOX_PRICES = [20, 50, 100];
        LOOTBOX_PROBABILITIES = [
                [60, 30, 10],
                [30, 50, 20],
                [10, 30, 60],
                [ 5, 15, 80]
            ];
        EGG_OPTIONS = 20;
        EGG_CLASSES = 3;
        CLASS_COLORS = ["Red", "Green", "Blue"];
        LOOTBOX = new EggLootBox(LOOTBOX_OPTIONS, EGG_OPTIONS, EGG_CLASSES);
        
        for(uint i = 0; i < LOOTBOX_OPTIONS; i++) {
            LOOTBOX.setOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
        
        EGG_TOKEN = new EggToken();
    }
    
    function buyLootBox(uint256 selectedOption) external {
        ERC20 CandyToken = ERC20(CANDY_ERC20);
        require(CandyToken.balanceOf(msg.sender) >= LOOTBOX_PRICES[selectedOption], "EggFactory::buyLootBox: User does not have sufficient Candies");
        
        uint256 returnedClass = LOOTBOX.mintAndOpen(selectedOption);
        //CandyToken._burn(msg.sender, LOOTBOX_PRICES[selectedOption]);
        
        EGG_TOKEN.mint(msg.sender, CLASS_COLORS[returnedClass]);
    }
}