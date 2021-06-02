// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./deps/IERC20.sol";
import "./deps/IEggLootBox.sol";
import "./deps/IEggToken.sol";

contract EggFactory {
    address SOURCE_TOKEN;
    address EGG_LOOTBOX;
    address EGG_TOKEN;
    uint256[] LOOTBOX_PRICES;
    uint256[][] LOOTBOX_PROBABILITIES;
    
    address factoryOwner;
    address delegatedOwner;
    
    modifier onlyOwner() {
        require(msg.sender == factoryOwner, "EggFactory: Only owner can perform this action");
        _;
    }
    
    modifier onlyDelegatedOwner() {
        require(msg.sender == factoryOwner || msg.sender == delegatedOwner, "EggFactory: Only owner or delegated owner can perform this action");
        _;
    }

    event EggMinted(address receiver, uint256 eggId);

    constructor() {
        factoryOwner = msg.sender;
    }
    
    function setSourceToken(address newAddress) external onlyDelegatedOwner {
        SOURCE_TOKEN = newAddress;
    }
    
    function setEggLootbox(address newAddress) external onlyDelegatedOwner {
        EGG_LOOTBOX = newAddress;
    }
    
    function setEggToken(address newAddress) external onlyDelegatedOwner {
        EGG_TOKEN = newAddress;
    }

    // [10,20,30,40]
    function setLootboxPrices(uint256[] memory newLootBoxPrices) external onlyDelegatedOwner {
        LOOTBOX_PRICES = newLootBoxPrices;
    }

    // [[5,30,65],[10,40,50],[15,40,45],[20,50,30]]
    function setLootboxProbabilities(uint256[][] memory newProbablities) external onlyDelegatedOwner {
        LOOTBOX_PROBABILITIES = newProbablities;
        _refreshEggLootbox();
    }
    
    function setDelegatedOwner(address newAddress) external onlyOwner {
        delegatedOwner = newAddress;
    }
    
    function setFactoryOwner(address newAddress) external onlyOwner {
        factoryOwner = newAddress;
    }
    
    function _refreshEggLootbox() internal {
        (string[] memory eggClassNames, ) = IEggToken(EGG_TOKEN).getEggClasses();
        IEggLootBox(EGG_LOOTBOX).setEggLootBoxState(LOOTBOX_PRICES.length, eggClassNames.length);
        for (uint i = 0; i < LOOTBOX_PRICES.length; i++) {
            IEggLootBox(EGG_LOOTBOX).setEggOptionClasses(i, LOOTBOX_PROBABILITIES[i]);
        }
    }
    
    function refreshEggLootbox() external onlyDelegatedOwner {
        _refreshEggLootbox();
    }
    
    function getSourceToken() external view returns(address) {
        return SOURCE_TOKEN;
    }
    
    function getEggLootbox() external view returns(address) {
        return EGG_LOOTBOX;
    }
    
    function getEggToken() external view returns(address) {
        return EGG_TOKEN;
    }
    
    function getLootboxPrices() external view returns(uint256[] memory) {
        return LOOTBOX_PRICES;
    }
    
    function getLootboxProbabilities() external view returns(uint256[][] memory) {
        return LOOTBOX_PROBABILITIES;
    }
    
    function getDelegatedOwner() external view returns(address) {
        return delegatedOwner;
    }
    
    function getFactoryOwner() external view returns(address) {
        return factoryOwner;
    }
    
    function buyLootbox(uint256 selectedClass) external returns(uint256 mintedEggId) {
        require(selectedClass < LOOTBOX_PRICES.length, "EggFactory::byLootbox: Unknown class selected");
        IERC20 st = IERC20(SOURCE_TOKEN);
        require(st.balanceOf(msg.sender) >= LOOTBOX_PRICES[selectedClass], "EggFactory::buyLootbox: User does not have sufficient credits");
        st.transferFrom(msg.sender, address(this), LOOTBOX_PRICES[selectedClass]);
        uint256 randClass = IEggLootBox(EGG_LOOTBOX).mintAndOpen(selectedClass);
        mintedEggId = IEggToken(EGG_TOKEN).mintRandom(msg.sender, randClass);
        emit EggMinted(msg.sender, mintedEggId);
    }
}