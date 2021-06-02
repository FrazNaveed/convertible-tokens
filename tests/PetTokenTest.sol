pragma solidity ^0.8.0;

import "../PetToken.sol";

contract PetTokenTest is PetToken {
    constructor() PetToken("Pet Token", "PTK") {
        addPet("Puppy");
        addPet("Kitten");
        addPet("Panda");
        addPet("Duckling");
    }
    
    function testRandomizer(uint256[] memory sampleClass) external returns(uint256 randomPetId, string memory randomPetName) {
        (randomPetId, randomPetName) = mintRandom(sampleClass);
    }
}