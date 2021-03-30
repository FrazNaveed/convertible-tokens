pragma solidity ^0.8.0;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol';
import './RewardERC721.sol';

contract LootBox is ERC721 {
    uint256 NUMBER_OPTIONS;     // Number of options we have per lootbox
    uint256 RANDOM_NONCE;       // A random number to seed the randomizer
    address REWARDING_FACTORY;  // Address of the contract whos instances are rewarded
    
    event lootBoxUnpacked(address owner, uint256 rewardOption);
    
    constructor(string memory name_, string memory symbol_, address _factoryAddress) ERC721(name_, symbol_) {
        NUMBER_OPTIONS = 4;
        RANDOM_NONCE = 0;
        REWARDING_FACTORY = _factoryAddress;
    }
    
    function unpack(uint256 _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender);

        // Custom logic for configuring the item
        uint256 randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, RANDOM_NONCE++))) % 100;

        uint256 selectedOption = randomNumber >= 0 && randomNumber < 10 ? 0 : // 10% chances for blue
                                 randomNumber >= 10 && randomNumber < 20 ? 1 : // 10% chances for green
                                 randomNumber >= 20 && randomNumber < 70 ? 2 : // 50% chances for red
                                 3; // Remainder 20% chances for orange

        RewardERC721 reward = RewardERC721(REWARDING_FACTORY);
        reward.mint(msg.sender, selectedOption);
        emit lootBoxUnpacked(msg.sender, selectedOption);

        // Burn the presale item.
        _burn(_tokenId);
    }
    
    function baseTokenURI() public pure returns (string memory) {
        return "";
    }

    function itemsPerLootbox() public view returns (uint256) {
        return NUMBER_OPTIONS;
    }
}