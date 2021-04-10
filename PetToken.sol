pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract PetToken is ERC721 {
    uint256 RANDOM_NONCE;
    uint256 PETS_COUNT;
    mapping(uint256 => string) PET_ID_NAMES;
    mapping(string => uint256) PET_NAME_IDS;
    
    uint256 MINTED_COUNT;
    mapping(uint256 => string) MINTED_ID_NAME;
    
    address owner;
    address petFactory;
    
    modifier onlyOwner() {
        require(msg.sender == owner || msg.sender == petFactory, "PetToken: This action can only be performed by owner or PetFactory");
        _;
    }
    
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        RANDOM_NONCE = 0;
        MINTED_COUNT = 0;
        owner = msg.sender;
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    function setParentFactory(address newPetFactory) external onlyOwner {
        eggFactory = newPetFactory;
    }
    
    function getOwners() external view returns(address, address) {
        return(owner, eggFactory);
    }
    
    function addPet(string memory petName) external onlyOwner {
        require(PET_NAME_IDS[petName] == 0, "PetToken::addPet: A pet with same name already exists");
        PET_ID_NAMES[PETS_COUNT++] = petName;
    }
    
    function getPetFromId(uint256 id) external view returns(string memory) {
        return PET_ID_NAMES[id];
    }
    
    function mintRandom(uint256[] memory classProbabilities) external onlyOwner returns(uint256, string memory) {
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
        _mint(msg.sender, ++MINTED_COUNT);
        MINTED_ID_NAME[MINTED_COUNT] = PET_ID_NAMES[selectedClass];
        return (MINTED_COUNT, PET_ID_NAMES[selectedClass]);
    }
}