// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.38;

contract Bank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient funds!");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer Failed!");

        balances[msg.sender] = 0;
    }
}
