pragma solidity ^0.8.0;

import "../LootBoxRandomness.sol";

contract LootBoxRandomnessTest is LootBoxRandomness {
    constructor(uint256 assetClasses, uint256[] memory classes) LootBoxRandomness(assetClasses) {
        _setRandomizerClasses(classes);
        _mintRandom(); // LootBoxRandomness automatically fires "RandomSelected" event so no need logging
    }
}