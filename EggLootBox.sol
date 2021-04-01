pragma solidity ^0.8.0;

import "./LootBoxRandomness.sol";

contract EggLootBox is LootBoxRandomness {
    uint256 LOOTBOX_OPTIONS;
    mapping (uint256 => uint256[]) LOOTBOX_OPTION_PROBABILITIES;
    
    constructor(uint256 lootboxOptions, uint256 _eggOptions, uint256 _eggClasses)
    LootBoxRandomness(_eggOptions, _eggClasses)
    {
        LOOTBOX_OPTIONS = lootboxOptions;
    }
    
    function setEggLootBoxState(uint256 newEggOptions, uint256 newEggClasses) public {
        _setLootBoxState(newEggOptions, newEggClasses);
    }
    
    function getEggLootBoxState() public view returns(uint256, uint256) {
        return _getLootBoxState();
    }
    
    function setEggOptionClasses(uint256 lootBox, uint256[] memory probabilities) public {
        LOOTBOX_OPTION_PROBABILITIES[lootBox] = probabilities;        
    }
    
    function mintAndOpen(uint256 selectedOption) public returns(uint256) {
        _setRandomizerClasses(LOOTBOX_OPTION_PROBABILITIES[selectedOption]);
        uint256 randomClass = _mintRandom();
        return randomClass;
    }
}