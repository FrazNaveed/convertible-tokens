pragma solidity ^0.8.0;

import "../EggLootBox.sol";


contract EggLootBoxTest is EggLootBox {
    event EggLootBoxTestResults(uint256 selectedClass);
    
    constructor(uint256 optionsCount, uint256 classCount, uint256[] memory firstBoxProbabilities)
    EggLootBox(optionsCount, classCount) {
        setEggOptionClasses(0, firstBoxProbabilities);
        uint256 selectedClass = mintAndOpen(0);
        emit EggLootBoxTestResults(selectedClass);
    }
}