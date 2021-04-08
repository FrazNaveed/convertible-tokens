pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract LootBoxRandomness {
    using SafeMath for uint256;
    
    uint256 ASSET_CLASSES;
    uint256 RANDOM_NONCE;
    mapping (uint256 => uint256) PROBABILITY_BOUNDARIES;
    
    event RandomSelected(uint256 randomizedNumber, uint256 selectedOption, uint256  );

    constructor(uint256 assetClasses) {
        ASSET_CLASSES = assetClasses;
        RANDOM_NONCE = 0;
    }
    
    function _setLootBoxState(uint256 newAssetClasses) internal {
        ASSET_CLASSES = newAssetClasses;
    }
    
    function _getLootBoxState() internal view returns(uint256) {
        return ASSET_CLASSES;
    }
    
    function _setRandomizerClasses(uint256[] memory classProbabilityBoundaries) internal {
        uint256 sumSoFar = 0;
        for(uint256 i = 0; i < ASSET_CLASSES; i++) {
            sumSoFar = sumSoFar.add(classProbabilityBoundaries[i]);
            PROBABILITY_BOUNDARIES[i] = sumSoFar;
        }
        require(sumSoFar == 100, "LootBoxRandomness::setRandomizerClasses: Class probabilities should add up to 100");
    }
    
    function _mintRandom() internal returns(uint256) {
        RANDOM_NONCE = (RANDOM_NONCE + 1).mod(1000000000); // Prevent integer overflow on uint256
        uint256 randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, RANDOM_NONCE))).mod(100);

        uint256 selectedClass;
        
        for(uint256 i = 0; i < ASSET_CLASSES; i++) {
            if (randomNumber < PROBABILITY_BOUNDARIES[i]) {
                selectedClass = i;
                break;
            }
        }
        
        emit RandomSelected(randomNumber, selectedClass, PROBABILITY_BOUNDARIES[selectedClass]);
        
        return selectedClass;
    }
}