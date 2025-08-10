// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// local deploy:
// forge script script/Deploy.s.sol --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --rpc-url http://127.0.0.1:8545 --broadcast

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
			address(0), 
			new WETH9(), 
			IPool(address(0)), 
			IRewardsController(address(0))
		);

		console.log("MafiaCaster deployed at:", address(mafiaCaster));

        MafiaCaster.Mission memory mission = MafiaCaster.Mission({
            enable: true,
            energyConsume: 1,
            winOdds: 0.7 ether,
            reqAmount: 0,
            reqIds1155: new uint256[](0),
            reqAmounts1155: new uint256[](0),
            rewAmount: 4 ether,
            rewIds1155: new uint256[](0),
            rewAmounts1155: new uint256[](0)
        });
        mafiaCaster.addMission(mission);

        payable(0xB182fEEad77A88B30611E3Aa5847F148d81768b3).transfer(1 ether);

        mafiaCaster.doMission(1);

        console.log(address(mafiaCaster.money()));
        console.log(address(mafiaCaster.items()));

		vm.stopBroadcast();
	}
}
