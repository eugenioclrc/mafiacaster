// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Money is Ownable, ERC20 {
    address immutable Manager;
    
    constructor (address _owner) Ownable(_owner) ERC20("Money", "$"){
        Manager = msg.sender;
    }

    modifier canManage() {
        require(msg.sender == Manager || msg.sender == owner(), "Not access");
        _;
    }

    function mint(
        address to, 
        uint256 amount
    ) external canManage{
        _mint(to, amount);
    }

    function burn(
        address from, 
        uint256 amount
    ) external canManage {
        _burn(from, amount);
    } 
}
