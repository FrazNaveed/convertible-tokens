pragma solidity ^0.8.0;

interface IPetToken {
    function transferOwnership(address) external;
    
    function setParentFactory(address) external;
    
    function getOwners() external view returns(address, address);
    
    function addPet(string memory, string memory) external;
    
    function getPetFromId(uint256) external view returns(string memory, string memory);
    
    function getMintedPet(uint256) external view returns(string memory, string memory);
    
    function mintRandom(address, uint256[] memory) external returns(uint256, string memory);
}