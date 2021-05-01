pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract CandyToken is ERC20 {
    address owner;
    
    constructor() ERC20("Candy Token", "CTK") {
        owner = msg.sender;
    }
    
    function mintOwner(uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint for themselves");
        _mint(msg.sender, amount);
    }
}

// orange,black,burgundy,red,blue,navy,yellow,green,cyan,purple,brown,pink,orange,skin,grey1,grey2,grey3,grey4,grey5,grey6