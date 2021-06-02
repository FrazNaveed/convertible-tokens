// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./deps/IEggLootBox.sol";
import "./LootBoxRandomness.sol";

contract EggLootBox is LootBoxRandomness, IEggLootBox {
    uint256 LOOTBOX_OPTIONS;
    mapping (uint256 => uint256[]) LOOTBOX_OPTION_PROBABILITIES;
    
    constructor(uint256 lootboxOptions, uint256 _eggClasses)
    LootBoxRandomness(_eggClasses)
    {
        LOOTBOX_OPTIONS = lootboxOptions;
    }
    
    function setEggLootBoxState(uint256 newLootBoxOptions, uint256 newEggClasses) override public {
        LOOTBOX_OPTIONS = newLootBoxOptions;
        _setLootBoxState(newEggClasses);
    }
    
    function getEggLootBoxState() override public view returns(uint256, uint256) {
        uint256 eggClasses  = _getLootBoxState();
        return (LOOTBOX_OPTIONS, eggClasses);
    }
    
    function setEggOptionClasses(uint256 lootBox, uint256[] memory probabilities) override public {
        LOOTBOX_OPTION_PROBABILITIES[lootBox] = probabilities;        
    }
    
    function mintAndOpen(uint256 selectedOption) override public returns(uint256 randomClass) {
        _setRandomizerClasses(LOOTBOX_OPTION_PROBABILITIES[selectedOption]);
        randomClass = _mintRandom();
    }
}