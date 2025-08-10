// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {MockUSDbC} from "../src/mocks/MockUSDbC.sol";
import {MafiaCaster} from "../src/MafiaCaster.sol";

contract Test_MafiaCaster is Test {
    MockUSDbC USDbC = new MockUSDbC();
    MafiaCaster mafia;
    address owner = address(0x1000000000000000000000000000000000000001);
    address player = address(0x2000000000000000000000000000000000000002);
    
    function setUp() public { 
        vm.prank(owner);
        mafia = new MafiaCaster(IERC20(USDbC));
    }

    function test_constructor() public {
        assertEq(address(mafia.USDbC()), address(USDbC));
        assertEq(mafia.items().owner(), owner);
        assertEq(mafia.money().owner(), owner);
        assertEq(mafia.feePerEnergy(), 1 ether);
        assertEq(mafia.timePerEnergy(), 10 minutes);
        
    }

    function test_addMission() public {
        MafiaCaster.Mission memory mission = MafiaCaster.Mission({
            enable: true,
            energyConsume: 1,
            winOdds: 2,
            reqAmount: 3,
            reqIds1155: new uint256[](1),
            reqAmounts1155: new uint256[](1),
            rewAmount: 4,
            rewIds1155: new uint256[](1),
            rewAmounts1155: new uint256[](1)
        });

        vm.prank(owner);
        mafia.addMission(mission);
    }

    function test_toggleMissionEnable() public {
        vm.startPrank(owner);
        uint256 id = mafia.addMission(_getDefaultMission());

        (bool enable,,,,) = mafia.missions(id);
        assertEq(enable, false);

        mafia.toggleMissionEnable(id);
        
        (enable,,,,) = mafia.missions(id);
        assertEq(enable, true);
    }

    function test_setFeePerEnergy() public {
        assertEq(mafia.feePerEnergy(), 1 ether);
        
        vm.prank(owner);
        mafia.setFeePerEnergy(1);
        
        assertEq(mafia.feePerEnergy(), 1);
    }

    function test_setTimePerEnergy() public {
        assertEq(mafia.timePerEnergy(), 10 minutes);
        
        vm.prank(owner);
        mafia.setTimePerEnergy(1);
        
        assertEq(mafia.timePerEnergy(), 1);
    }

    function test_setInvestTime() public {
        assertEq(mafia.investTime(), 30 days);
        
        vm.prank(owner);
        mafia.setInvestTime(1);
        
        assertEq(mafia.investTime(), 1);
    }

    function test_doMission_loss() public {
        MafiaCaster.Mission memory mission = _getDefaultMission();
        mission.enable = true;
        mission.energyConsume = 1;
        mission.winOdds = 0;
        mission.reqAmount = 3;
        mission.reqIds1155[0] = 4;
        mission.reqAmounts1155[0] = 5;
        mission.rewAmount = 6;
        mission.rewIds1155[0] = 7;
        mission.rewAmounts1155[0] = 8;

        vm.startPrank(owner);
        uint256 id = mafia.addMission(mission);
        mafia.money().mint(player, 3);
        mafia.items().mintBatch(player, mission.reqIds1155, mission.reqAmounts1155);
        
        vm.startPrank(player);
        mafia.claimEnergy();
        USDbC.approve(address(mafia), 3);
        
        mafia.doMission(id);

        assertEq(mafia.money().balanceOf(player), 0);
        assertEq(mafia.items().balanceOf(player, 7), 0);
    }

    function test_doMission_win() public {
        MafiaCaster.Mission memory mission = _getDefaultMission();
        mission.enable = true;
        mission.energyConsume = 1;
        mission.winOdds = 1 ether;
        mission.reqAmount = 3;
        mission.reqIds1155[0] = 4;
        mission.reqAmounts1155[0] = 5;
        mission.rewAmount = 6;
        mission.rewIds1155[0] = 7;
        mission.rewAmounts1155[0] = 8;

        vm.startPrank(owner);
        uint256 id = mafia.addMission(mission);
        mafia.money().mint(player, 3);
        mafia.items().mintBatch(player, mission.reqIds1155, mission.reqAmounts1155);
        
        vm.startPrank(player);
        mafia.claimEnergy();
        USDbC.approve(address(mafia), 3);
        
        mafia.doMission(id);

        assertEq(mafia.money().balanceOf(player), 6);
        assertEq(mafia.items().balanceOf(player, 7), 8);
    }

    function test_claimEnergy() public {
        (uint256 lastEnergyClaimed, uint256 energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, 0);
        assertEq(energy, 0);
        
        vm.prank(player);
        mafia.claimEnergy();
        
        (lastEnergyClaimed, energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, block.timestamp);
        assertEq(energy, 100);
    }

    function test_claimEnergy_after() public {
        vm.prank(player);
        mafia.claimEnergy();
        // Spend energy
        vm.startPrank(owner);
        MafiaCaster.Mission memory mission = _getDefaultMission();
        mission.enable = true;
        mission.energyConsume = 70;
        uint256 id = mafia.addMission(mission);
        vm.startPrank(player);
        mafia.doMission(id);
            
        (uint256 lastEnergyClaimed, uint256 energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, block.timestamp);
        assertEq(energy, 30);
        
        vm.warp(block.timestamp + 6050);
        mafia.claimEnergy();
        
        (lastEnergyClaimed, energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, block.timestamp);
        assertEq(energy, 40);
    }

    function test_claimEnergy_moreThanMax() public {
        vm.prank(player);
        mafia.claimEnergy();
        // Spend energy
        vm.startPrank(owner);
        MafiaCaster.Mission memory mission = _getDefaultMission();
        mission.enable = true;
        mission.energyConsume = 1;
        uint256 id = mafia.addMission(mission);
        vm.startPrank(player);
        mafia.doMission(id);
            
        (uint256 lastEnergyClaimed, uint256 energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, block.timestamp);
        assertEq(energy, 99);
        
        vm.warp(block.timestamp + 6050);
        mafia.claimEnergy();
        
        (lastEnergyClaimed, energy) = mafia.users(player);
        assertEq(lastEnergyClaimed, block.timestamp);
        assertEq(energy, 100);
    }

    function test_buyEnergy() public {
        vm.prank(player);
        mafia.claimEnergy();
        // Spend energy
        vm.startPrank(owner);
        MafiaCaster.Mission memory mission = _getDefaultMission();
        mission.enable = true;
        mission.energyConsume = 30;
        uint256 id = mafia.addMission(mission);
        vm.startPrank(player);
        mafia.doMission(id);
        USDbC.mint(player, 7 * mafia.feePerEnergy());
        
        (, uint256 energy) = mafia.users(player);
        assertEq(energy, 70);
        
        USDbC.approve(address(mafia), 7 * mafia.feePerEnergy());
        mafia.buyEnergy(7);
        
        (, energy) = mafia.users(player);
        assertEq(energy, 77);
        (uint256 endTime, uint256 amount) = mafia.getUsersInvest(player, 0);
        assertEq(endTime, block.timestamp + mafia.investTime());
        assertEq(amount, 7 * mafia.feePerEnergy());
        USDbC.mint(player, 23 * mafia.feePerEnergy());

        USDbC.approve(address(mafia), 23 * mafia.feePerEnergy());
        mafia.buyEnergy(10000);
        
        (, energy) = mafia.users(player);
        assertEq(energy, 100);
        (endTime, amount) = mafia.getUsersInvest(player, 0);
        assertEq(endTime, block.timestamp + mafia.investTime());
        assertEq(amount, 23 * mafia.feePerEnergy());
    }

    // Helpers

    function _getDefaultMission() internal returns(MafiaCaster.Mission memory mission) {
        return MafiaCaster.Mission({
            enable: false,
            energyConsume: 0,
            winOdds: 0,
            reqAmount: 0,
            reqIds1155: new uint256[](1),
            reqAmounts1155: new uint256[](1),
            rewAmount: 0,
            rewIds1155: new uint256[](1),
            rewAmounts1155: new uint256[](1)
        });
    }
}
