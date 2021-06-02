// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

interface IPetToken {
    struct petMetadata {
        string name;
        string visual;
        uint256 hp;
        uint256 attack;
        uint256 defence;
        uint256 special1;
        uint256 special2;
    }

    function transferOwnership(address) external;
    
    function setParentFactory(address) external;
    
    function getOwners() external view returns(address, address);
    
    // function addPet(string memory, string memory) external;
    
    // function updatePetData(uint256, string memory, string memory) external;

    function getUserPets(address) external view returns(uint256[] memory);

    // function getPetFromId(uint256) external view returns(string memory, string memory);
    
    function getMintedPet(uint256) external view returns(petMetadata memory);
    
    // function getAllPets() external view returns(string[] memory, string[] memory);

    // function mintRandom(address, uint256[] memory) external returns(uint256, string memory);

    function mintPet(address, string memory, string memory, uint256, uint256, uint256, uint256, uint256) external returns(uint256);
}