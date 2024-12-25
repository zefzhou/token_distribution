// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenDistributor {
    address payable public owner;
    address public claimer;

    constructor(address claimer_) payable {
        owner = payable(msg.sender);
        claimer = claimer_;
    }

    receive() external payable {}

    function disperseEther(
        address[] memory recipients,
        uint256[] memory values
    ) external payable {
        for (uint256 i = 0; i < recipients.length; i++)
            payable(recipients[i]).transfer(values[i]);
        uint256 balance = address(this).balance;
        if (balance > 0) payable(msg.sender).transfer(balance);
    }

    function disperseToken(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) total += values[i];
        require(token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transfer(recipients[i], values[i]));
    }

    function claimEther(uint256 amount) public returns (bool) {
        if (amount == 0) {
            amount = address(this).balance;
        }
        require(
            amount <= address(this).balance,
            "no enough native token balance"
        );
        payable(claimer).transfer(amount);
        return msg.sender == claimer;
    }

    function claimToken(address token, uint256 amount) public returns (bool) {
        if (amount == 0) {
            amount = IERC20(token).balanceOf(address(this));
        }
        require(
            amount <= IERC20(token).balanceOf(address(this)),
            "no enough token balance"
        );
        IERC20(token).transfer(claimer, amount);
        return msg.sender == claimer;
    }
}
