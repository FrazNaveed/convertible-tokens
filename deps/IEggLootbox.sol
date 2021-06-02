pragma solidity ^0.8.0;

interface IEggLootBox{
    function setEggLootBoxState(uint256, uint256) external;
    
    function getEggLootBoxState() external view returns(uint256, uint256);
    
    function setEggOptionClasses(uint256, uint256[] memory) external;
    
    function mintAndOpen(uint256) external returns(uint256);
}