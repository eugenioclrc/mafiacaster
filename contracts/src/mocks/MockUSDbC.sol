// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockUSDbC is ERC20("USDbC", "USDbC") {
    function mint(
        address to, 
        uint256 amount
    ) external {
        _mint(to, amount);
    }
}
