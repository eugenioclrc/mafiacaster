// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IRewardsController} from "../interfaces/IRewardsController.sol";

contract MockRewardsController is IRewardsController {
    function claimAllRewardsToSelf(
        address[] calldata assets
    ) external returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
        
    }
}
