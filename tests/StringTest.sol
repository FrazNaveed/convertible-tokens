pragma solidity ^0.8.0;

contract StringTest {
    function test(string memory str1, string memory str2) external pure {
        require(keccak256(bytes("str1")) == keccak256(bytes(str2)), "Mismatch!");
    }
}