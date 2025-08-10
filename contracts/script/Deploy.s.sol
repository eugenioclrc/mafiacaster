// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MafiaCaster} from "../src/MafiaCaster.sol";
import {console} from "forge-std/console.sol";
import {WETH9} from "../src/mocks/WETH9.sol";
import {IPool} from "../src/interfaces/IPool.sol";
import {IRewardsController} from "../src/interfaces/IRewardsController.sol";

contract DeployScript is Script {
	function run() external {
		vm.startBroadcast();

		MafiaCaster mafiaCaster = new MafiaCaster(
			new WETH9(), 
			IPool(address(0)), 
			IRewardsController(address(0))
		);

		console.log("MafiaCaster deployed at:", address(mafiaCaster));

		vm.stopBroadcast();
	}
}
