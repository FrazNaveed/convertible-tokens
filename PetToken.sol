pragma solidity ^0.8.0;

import "./deps/IPetToken.sol";
import "./deps/ERC721.sol";

contract PetToken is ERC721, IPetToken {
    uint256 RANDOM_NONCE;
    string[] PET_NAMES;
    string[] PET_VISUALS;
    
    uint256 MINTED_COUNT;
    mapping(uint256 => uint256) MINTED_PETS; // uniqueToken => petId
    mapping(address => uint256[]) userBalance; // address => uniqueToken
    
    address owner;
    address eggFactory;
    
    modifier onlyOwner() {
        require(msg.sender == owner || msg.sender == eggFactory, "PetToken: This action can only be performed by owner or PetFactory");
        _;
    }
    
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        RANDOM_NONCE = 0;
        MINTED_COUNT = 0;
        owner = msg.sender;
    }
    
    function transferOwnership(address newOwner) external override onlyOwner {
        owner = newOwner;
    }
    
    function setParentFactory(address newPetFactory) external override onlyOwner {
        eggFactory = newPetFactory;
    }
    
    function getOwners() external override view returns(address, address) {
        return(owner, eggFactory);
    }
    
    function addPet(string memory petName, string memory petVisual) external override onlyOwner {
        PET_NAMES.push(petName);
        PET_VISUALS.push(petVisual);
    }
    
    function updatePetData(uint256 id, string memory newName, string memory newVisual) external override onlyOwner {
        PET_NAMES[id] = newName;
        PET_VISUALS[id] = newVisual;
    }

    function getUserPets(address user) external view override returns(uint256[] memory pets) {
        pets = userBalance[user];
    }

    function getPetFromId(uint256 id) external view override returns(string memory name, string memory visual) {
        name = PET_NAMES[id];
        visual = PET_VISUALS[id];
    }
    
    function getMintedPet(uint256 mintedId) external view override returns(string memory petName, string memory petVisual) {
        uint256 petId = MINTED_PETS[mintedId];
        petName = PET_NAMES[petId];
        petVisual = PET_VISUALS[petId];
    }

    function getAllPets() external view override returns(string[] memory names, string[] memory visuals) {
        names = PET_NAMES;
        visuals = PET_VISUALS;
    }
    
    function mintRandom(address receiver, uint256[] memory classProbabilities) external override onlyOwner returns(uint256, string memory) {
        uint256 randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, RANDOM_NONCE++))) % 100;
        uint256 sumSoFar = 0;
        uint256 selectedClass = 0;
        for (uint256 i = 0; i < classProbabilities.length; i++) {
            sumSoFar += classProbabilities[i];
            if (randomNumber <= sumSoFar) {
                selectedClass = i;
                break;
            }
        }
        _mint(receiver, ++MINTED_COUNT);
        MINTED_PETS[MINTED_COUNT] = selectedClass;
        userBalance[receiver].push(MINTED_COUNT);
        return (MINTED_COUNT, PET_NAMES[selectedClass]);
    }
}