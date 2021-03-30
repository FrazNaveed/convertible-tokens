pragma solidity ^0.8.0;

import "./LootBoxERC721.sol";

contract LootBoxBuyer {
    uint256 ERC20_RATE;     // Number of ERC20 tokens required to purchase 1 lootbox
    uint256 ERC721_RATE;    // Number of ERC721 tokens required to purchase 1 lootbox
    uint256 ERC1155_RATE;   // Number of ERC1155 tokens required to purchase 1 lootbox
    
    constructor(uint256 erc20_rate, uint256 erc721_rate, uint256 erc1155_rate) {
        ERC20_RATE = erc20_rate;
        ERC721_RATE = erc721_rate;
        ERC1155_RATE = erc1155_rate;
    }
    
    function buyWithERC20() public returns(address) {
        // Check sender's balance >= ERC20_RATE
        // Burn the sender's balance amount ERC20_RATE
        // Get an instance of LootBoxERC721
        // Return the address of instance
        return address(0);
    }
    function buyWithERC721() public returns(address) {
        return address(0);
    }
    function buyWithERC1155() public returns(address) {
        return address(0);
    }
}