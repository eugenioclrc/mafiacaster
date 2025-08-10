// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MafiaCaster} from "../src/MafiaCaster.sol";
import {MockUSDbC} from "../src/mocks/MockUSDbC.sol";
import {console} from "forge-std/console.sol";

contract DeployScript is Script {
	function run() external {
		// Start broadcasting transactions
		vm.startBroadcast();

		// Deploy MockUSDbC (mock stablecoin)
		MockUSDbC usdbc = new MockUSDbC();

		// Deploy MafiaCaster with the address of MockUSDbC
		MafiaCaster mafiaCaster = new MafiaCaster(usdbc);

		// Log deployed addresses
		console.log("MockUSDbC deployed at:", address(usdbc));
		console.log("MafiaCaster deployed at:", address(mafiaCaster));

		vm.stopBroadcast();
	}
}
