pragma solidity ^0.8.0;

import "./deps/IERC20.sol";
import "./deps/IERC721.sol";
import "./deps/IEggToken.sol";
import "./deps/IPetToken.sol";

contract PetFactory {
    address SOURCE_TOKEN;
    address EGG_TOKEN;
    address PET_TOKEN;
    uint256 PET_FEES;
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
        address petToken,
        uint256 petFees
    ) {
        SOURCE_TOKEN = sourceToken;
        EGG_TOKEN = eggToken;
        PET_TOKEN = petToken;
        PET_FEES = petFees;
        factoryOwner = msg.sender;
    }
    
    function setSourceToken(address newSource) external onlyDelegatedOwner {
        SOURCE_TOKEN = newSource;
    }
    
    function setEggToken(address newEgg) external onlyDelegatedOwner {
        EGG_TOKEN = newEgg;
    }
    
    function setPetFees(uint256 newFees) external onlyDelegatedOwner {
        PET_FEES = newFees;
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
    
    function getPetFees() external view returns(uint256) {
        return PET_FEES;
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
        IERC20 ct = IERC20(SOURCE_TOKEN);
        IEggToken et = IEggToken(EGG_TOKEN);
        IERC721 et721 = IERC721(EGG_TOKEN);
        IPetToken pt = IPetToken(PET_TOKEN);
        
        require(et721.ownerOf(eggId) == msg.sender, "PetFactory::buyPet: The sender is not owner of given egg");
        require(ct.balanceOf(msg.sender) >= PET_FEES, "PetFactory::buyPet: The sender does not have sufficient pet fees");
        
        (string memory name,,) = et.getEggFromId(eggId);
        uint256[] memory petProbabilities = EGG_PET_PROBABILITIES[name];
        
        uint256 newPetTokenId;
        string memory selectedPetClassName;
        (newPetTokenId, selectedPetClassName) = pt.mintRandom(msg.sender, petProbabilities);
        
        emit PetPurchased(msg.sender, newPetTokenId, selectedPetClassName);
        ct.transferFrom(msg.sender, address(this), PET_FEES);
        et.burn(eggId);
        return newPetTokenId;
    }
}