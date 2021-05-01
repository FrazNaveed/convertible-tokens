// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEggToken {
    function setEggRewards(string[] memory, string[] memory, string[] memory) external;

    function setEggClasses(string[] memory, uint256[][] memory) external;
    
    function setFactoryOwner(address) external;
    
    function setParentFactories(address, address) external;

    function getEggRewards() external view returns(string[] memory, string[] memory, string[] memory);

    function getEggClasses() external view returns(string[] memory, uint256[][] memory);

    function getEggFromId(uint256) external view returns(string memory, string memory, string memory);

    function getEggFromMintedId(uint256) external view returns(string memory, string memory, string memory);
    
    function getOwners() external view returns(address, address, address);
    
    function mintRandom(address, uint256) external returns(uint256);
    
    function burn(uint256) external;

    function pause() external;
    
    function unpause() external;
}