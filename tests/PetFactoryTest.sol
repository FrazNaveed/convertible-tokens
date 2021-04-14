pragma solidity ^0.8.0;

import "../CandyToken.sol";
import "../EggToken.sol";
import "../PetToken.sol";
import "../PetFactory.sol";

contract PetFactoryTest {
    CandyToken public ct;
    EggToken public et;
    PetToken public pt;
    PetFactory public pf;
    
    constructor() {
        ct = new CandyToken();
        et = new EggToken("EggToken", "ETK");
        et.transferOwnership(msg.sender);
        pt = new PetToken("PetToken", "PTK");
        pt.setParentFactory(address(this));
        pt.transferOwnership(msg.sender);
        pf = new PetFactory(address(ct), address(et), address(pt), 20);
        pf.transferFactoryOwnership(msg.sender);
    }
    
    function testPetFactory(string memory eggColor, uint256[] memory correspondingProbabilities, uint256 eggId) external returns(uint256) {
        pf.setEggPetProbabilities(eggColor, correspondingProbabilities);
        return pf.buyPet(eggId);
    }
}