pragma solidity ^0.8.0;

import "./CandyToken.sol";
import "./EggToken.sol";
import "./PetToken.sol";

contract PetFactory {
    address SOURCE_TOKEN;
    address EGG_TOKEN;
    address PET_TOKEN;
    mapping (string => uint256[]) EGG_PET_PROBABILITIES;
    
    address factoryOwner;
    address delegatedOwner;
    
    event PetPurchased(address purchaser, uint256 petTokenId, string petClass);
    
    modifier onlyOwner() {
        require(msg.sender == factoryOwner, "PetFactory: Only owner can perform this action.");
        _;
    }
    
    modifier onlyDelegatedOwner() {
        require(msg.sender == factoryOwner || msg.sender == delegatedOwner, "PetFactory: Only owner or delegated owner can perform this action");
        _;
    }
    
    constructor(
        address sourceToken,
        address eggToken,
        address petToken
    ) {
        SOURCE_TOKEN = sourceToken;
        EGG_TOKEN = eggToken;
        PET_TOKEN = petToken;
        factoryOwner = msg.sender;
    }
    
    function setSourceToken(address newSource) external onlyDelegatedOwner {
        SOURCE_TOKEN = newSource;
    }
    
    function setEggToken(address newEgg) external onlyDelegatedOwner {
        EGG_TOKEN = newEgg;
    }
    
    function setEggPetProbabilities(string memory eggColor, uint256[] memory probabilitiesList) external onlyDelegatedOwner {
        EGG_PET_PROBABILITIES[eggColor] = probabilitiesList;
    }
    
    function setDelegatedOwner(address newDelegate) external onlyOwner {
        delegatedOwner = newDelegate;
    }
    
    function transferFactoryOwnership(address newOwner) external onlyOwner {
        factoryOwner = newOwner;
    }
    
    function getSourceToken() external view returns(address) {
        return SOURCE_TOKEN;
    }
    
    function getEggToken() external view returns(address) {
        return EGG_TOKEN;
    }
    
    function getEggPetProbabilities(string memory eggColor) external view returns(uint256[] memory) {
        return EGG_PET_PROBABILITIES[eggColor];
    }
    
    function getFactoryOwner() external view returns(address) {
        return factoryOwner;
    }
    
    function getDelegatedOwner() external view returns(address) {
        return delegatedOwner;
    }
    
    function buyPet(uint256 eggId) external returns(uint256) {
        //CandyToken ct = CandyToken(SOURCE_TOKEN);
        EggToken et = EggToken(EGG_TOKEN);
        PetToken pt = PetToken(PET_TOKEN);
        
        require(et.ownerOf(eggId) == msg.sender, "PetFactory::buyPet: The sender is not owner of given egg");
        string memory eggColor = et.getEggColor(eggId);
        uint256[] memory petProbabilities = EGG_PET_PROBABILITIES[eggColor];
        
        uint256 newPetTokenId;
        string memory selectedPetClassName;
        (newPetTokenId, selectedPetClassName) = pt.mintRandom(petProbabilities);
        
        emit PetPurchased(msg.sender, newPetTokenId, selectedPetClassName);
        return newPetTokenId;
    }
}