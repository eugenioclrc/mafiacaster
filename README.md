# MafiaCaster

# Contracts

`MafiaCaster` is a gamified smart contract for managing missions, items, and in-game currency using ERC20 and ERC1155 tokens. It supports energy-based actions, missions with requirements and rewards, and integrates with Aave-like pools for yield on deposited funds.

## Deploys

- MafiaCaster: [0xDbc3Fa5DBD281BD00A8f5a770B05d963bb9565aA](https://sepolia.basescan.org/address/0xdbc3fa5dbd281bd00a8f5a770b05d963bb9565aa#code)
- Money: [0x156230e2c7Fb1901b6A7C6F04C3997Ba59f3D924](https://sepolia.basescan.org/address/0x156230e2c7Fb1901b6A7C6F04C3997Ba59f3D924#code)
- Items: [0xf914548D078446F514BBd33c067A5f7e99FaE5a2](https://sepolia.basescan.org/address/0xf914548D078446F514BBd33c067A5f7e99FaE5a2#code)

### Mission TXs

- Mission 1, loss: [0x4e67...8bb0](https://sepolia.basescan.org/tx/0x4e673dda5e2917af3bd9d63f6f09bde660841b4bee7846e30fd96b34c0f88bb0#eventlog)

- Mission 1, win money: [0xf9cd...fa0da](https://sepolia.basescan.org/tx/0xf9cd891701ad2af9fcd980208bf1b534ccac5d0cd1331e6ea6d41c99c1bfa0da#eventlog)

- Mission 1, win money: [0x60b1...18dc](https://sepolia.basescan.org/tx/0x60b1e76aebf6ab577f52d8c3e74dc9132afaefbff9f3442e8a28fcb0519818dc#eventlog)

- Mission 2, win money item 1 amount 2: [0x49f4...e3db](https://sepolia.basescan.org/tx/0x49f4f02945e7f606d810d8ea17d39614d46123be64f6397c8eb23b2030eae3db#eventlog)

- Mission 3, loss: [0x6dd5...07e4](https://sepolia.basescan.org/tx/0x6dd55ef5e7decd35078281371a052700db7aa61c7d94d844d0917a64ab5807e4#eventlog)

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
