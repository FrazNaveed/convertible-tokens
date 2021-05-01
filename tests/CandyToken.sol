pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract CandyToken is ERC20 {
    constructor() ERC20("Candy Token", "CTK") {}
    
    function mintOwner(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}