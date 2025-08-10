# MafiaCaster

# Contracts

`MafiaCaster` is a gamified smart contract for managing missions, items, and in-game currency using ERC20 and ERC1155 tokens. It supports energy-based actions, missions with requirements and rewards, and integrates with Aave-like pools for yield on deposited funds.

## Features

- **Missions:** Define missions with requirements (ERC20/1155) and rewards (ERC20/1155).
- **Energy System:** Users spend and claim energy to perform actions.
- **Investments:** Users can buy energy, which deposits funds into a pool for a fixed period.
- **Aave Integration:** Funds are supplied/withdrawn from a lending pool.
- **Rewards:** Protocol rewards can be claimed by the owner and are used to fund the protocol.

## Constructor

```solidity
constructor(
    IPool _pool,
    IRewardsController _rewardsController
)
```
- `_pool`: Lending pool contract (e.g., Aave).
- `_rewardsController`: Rewards controller for claiming protocol rewards.

## Main Functions

### Missions

- `addMission(Mission calldata mission)`: Add a new mission (owner only).
- `toggleMissionEnable(uint256 id)`: Enable/disable a mission (owner only).
- `doMission(uint256 id)`: Attempt a mission, spending energy and burning required tokens.

### Energy

- `claimEnergy()`: Claim energy based on elapsed time.
- `buyEnergy(uint256 amount)`: Buy energy with ether, which is deposited into the pool.

### Investments

- `returnFunds(uint256 investId)`: Withdraw invested funds after the lock period.

### Rewards

- `claimProtocolRewards()`: Owner claims all protocol rewards from the rewards controller. The rewards received from Aave are used to fund the protocol.

## Data Structures

- `Mission`: Requirements and rewards for a mission.
- `Invest`: User investment details.
- `User`: Tracks user energy, last claim, and investments.

## Utility Functions

- `getMissionReqIds1155`, `getMissionReqAmounts1155`, `getMissionRewIds1155`, `getMissionRewAmounts1155`: View mission requirements and rewards.
- `getUsersInvest(address user, uint256 id)`: View a user's investment.

## Security Notes

- Only the contract owner can add/toggle missions and claim protocol rewards.
- Randomness for mission outcomes uses `block.prevrandao`, which is not secure for high-value randomness.

## Example Usage

1. **Owner** adds a mission.
2. **User** claims energy.
3. **User** does a mission, spending energy and possibly receiving rewards.
4. **User** buys more energy (funds are invested).
5. **User** withdraws funds after investment period.
