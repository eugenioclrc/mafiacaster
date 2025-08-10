// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

import {WETH9} from "./mocks/WETH9.sol";
import {IPool} from "./interfaces/IPool.sol";
import {IRewardsController} from "./interfaces/IRewardsController.sol";
import {Items} from "./Items.sol";
import {Money} from "./Money.sol";

contract MafiaCaster is Ownable {
    struct Mission {
        bool enable;
        uint256 energyConsume;
        uint256 winOdds;
        // Requires
        uint256 reqAmount;
        uint256[] reqIds1155;
        uint256[] reqAmounts1155;
        // Rewards
        uint256 rewAmount;
        uint256[] rewIds1155;
        uint256[] rewAmounts1155;
    }

    struct Invest {
        uint256 endTime;
        uint256 amount;
    }

    struct User {
        uint256 lastEnergyClaimed;
        uint256 energy;
        Invest[] invests;
    }

    uint256 constant MAX_ENERGY = 100;
    uint256 constant MAX_ODDS = 1 ether;

    IPool public pool;
    WETH9 public weth;
    IRewardsController public rewardsController;
    
    Items public items;
    Money public money;
    uint256 public investTime = 30 days;
    uint256 public feePerEnergy = 1 ether;
    uint256 public timePerEnergy = 10 minutes;
    uint256 counterId = 1;

    mapping(uint256 id => Mission mission) public missions;

    mapping(address => User) public users;

    constructor (WETH9 _weth, IPool _pool, IRewardsController _rewardsController) Ownable(msg.sender) {
        items = new Items(msg.sender);
        money = new Money(msg.sender);
        pool = _pool;
        weth = _weth;
        rewardsController = _rewardsController;
        _weth.approve(address(_pool), type(uint256).max);
    }

    function getMissionReqIds1155(uint256 id) external view returns(uint256[] memory) {
        return missions[id].reqIds1155;
    }

    function getMissionReqAmounts1155(uint256 id) external view returns(uint256[] memory) {
        return missions[id].reqAmounts1155;
    }

    function getMissionRewIds1155(uint256 id) external view returns(uint256[] memory) {
        return missions[id].rewIds1155;
    }

    function getMissionRewAmounts1155(uint256 id) external view returns(uint256[] memory) {
        return missions[id].rewAmounts1155;
    }

    function getUsersInvest(address user, uint256 id) external view returns(uint256 endTime, uint256 amount) {
        Invest memory invest = users[user].invests[id];
        endTime = invest.endTime;
        amount = invest.amount;
    }

    function addMission(Mission calldata mission) external onlyOwner returns(uint256 id) {
        require(mission.winOdds <= MAX_ODDS, 'To odd');
        id = counterId++;
        missions[id] = mission;
    }

    function toggleMissionEnable(uint256 id) external onlyOwner {
        require(id < counterId && id != 0, 'The mission don\'t exists');
        missions[id].enable = !missions[id].enable;
    }

    function setFeePerEnergy(uint256 _feePerEnergy) external onlyOwner {
        feePerEnergy = _feePerEnergy;
    }

    function setTimePerEnergy(uint256 _timePerEnergy) external onlyOwner {
        timePerEnergy = _timePerEnergy;
    }

    function setInvestTime(uint256 _investTime) external onlyOwner {
        investTime = _investTime;
    }

    function claimProtocolRewards() external onlyOwner {
        address[] memory assets = new address[](1);
        assets[0] = address(weth); 
        rewardsController.claimAllRewardsToSelf(assets);
    }

    function doMission(uint256 id) external {
        if (users[msg.sender].lastEnergyClaimed == 0) {
            claimEnergy();
        }

        Mission memory mission = missions[id];
        require(mission.enable, 'Not enable');

        if (mission.reqAmount != 0) {
            money.burn(msg.sender, mission.reqAmount);
        }
        if (mission.reqIds1155.length != 0) {
            items.burnBatch(msg.sender, mission.reqIds1155, mission.reqAmounts1155);
        }

        users[msg.sender].energy -= mission.energyConsume;
        
        if (_hasWon(mission.winOdds)) {
            if (mission.rewAmount != 0) {
                money.mint(msg.sender, mission.rewAmount);
            }
            if (mission.rewIds1155.length != 0) {
                items.mintBatch(msg.sender, mission.rewIds1155, mission.rewAmounts1155);
            }
        }
    }

    function claimEnergy() public {
        uint256 energy;
        if (users[msg.sender].lastEnergyClaimed == 0) {
            energy = 20;
        } else {
            energy = (block.timestamp - users[msg.sender].lastEnergyClaimed) / timePerEnergy;
            require(energy != 0, 'Nothing to claim');
            energy += users[msg.sender].energy;
            if (energy > MAX_ENERGY) energy = MAX_ENERGY;
        }

        users[msg.sender].energy = energy;
        users[msg.sender].lastEnergyClaimed = block.timestamp;
    }

    function buyEnergy(uint256 amount) external payable {
        require(users[msg.sender].lastEnergyClaimed != 0, 'First claim energy');
        uint256 deltaE = MAX_ENERGY - users[msg.sender].energy; 
        if (amount > deltaE) {
            amount = deltaE;
        }

        uint256 ethAmount = amount * feePerEnergy;

        weth.deposit{value: ethAmount}();
        users[msg.sender].invests.push(Invest({
            endTime: block.timestamp + investTime,
            amount: ethAmount
        }));
        users[msg.sender].energy += amount;

        _supplyAave(ethAmount);

        if (msg.value > ethAmount) {
            payable(msg.sender).call{value: msg.value - ethAmount}("");
        }
    }

    function returnFunds(uint256 investId) external {
        Invest memory invest = users[msg.sender].invests[investId];
        require(invest.amount > 0, "Already returned");
        require(invest.endTime >= block.timestamp, "Not yet");

        _withdrawAave(invest.amount);

        weth.transfer(msg.sender, invest.amount);  
        users[msg.sender].invests[investId].amount = 0;
    }

    function _supplyAave(uint256 ethAmount) internal {
        if (address(pool) != address(0)) {
            pool.supply(address(weth), ethAmount, address(this), 0);
        }
    }

    function _withdrawAave(uint256 ethAmount) internal {
        if (address(pool) != address(0)) {
            pool.withdraw(address(weth), ethAmount, address(this));
        }
    }

    function _hasWon(uint256 odds) internal view returns (bool) {
        uint256 random = uint256(
            keccak256(abi.encodePacked(block.prevrandao, msg.sender, block.timestamp))
        ) % MAX_ODDS;

        return random < odds;
    }
}
