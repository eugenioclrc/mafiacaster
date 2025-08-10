// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract Items is Ownable, ERC1155 {
    address immutable Manager;
    
    constructor (address _owner) Ownable(_owner) ERC1155(""){
        Manager = msg.sender;
    }

    modifier canManage() {
        require(msg.sender == Manager || msg.sender == owner(), "Not access");
        _;
    }

    function mintBatch(
        address to, 
        uint256[] memory ids, 
        uint256[] memory values
    ) external canManage{
        _mintBatch(to, ids, values, '');
    }

    function burnBatch(
        address from, 
        uint256[] memory ids, 
        uint256[] memory values
    ) external canManage {
        _burnBatch(from, ids, values);
    } 
}
