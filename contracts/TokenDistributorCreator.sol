// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TokenDistributor} from "./TokenDistributor.sol";

contract TokenDistributorCreator {
    address public owner;
    mapping(address => address) public claimer_to_contract;

    constructor() {
        owner = msg.sender;
    }

    function deploy(address[] memory claimers) public {
        require(msg.sender == owner, "only owner allowed to deploy");
        for (uint i = 0; i < claimers.length; i++) {
            if (claimer_to_contract[claimers[i]] == address(0x0)) {
                TokenDistributor td = new TokenDistributor(claimers[i]);
                claimer_to_contract[claimers[i]] = address(td);
            }
        }
    }
}
