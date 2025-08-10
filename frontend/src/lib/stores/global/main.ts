import { writable, get } from "svelte/store";
import type { WalletConfig } from "$lib/types/frame-sdk";

import { sendTransaction, readContract } from "@wagmi/core";
import { baseSepolia } from "wagmi/chains";

export const pageLoading = writable(true);
export const navigationLoading = writable(false);
export const frameWalletConfig = writable<WalletConfig>(
  null as unknown as WalletConfig,
);
export const isViewingFromFrame = writable(false);
export const isWalletReady = writable(false);
export const userWallet = writable<string | null>(null);

export const userEnergy = writable<bigint>(0n);
export const userLastEnergyClaimed = writable<bigint>(0n);

export async function loadUserData() {
  if (!get(isWalletReady)) return;
  const user = get(userWallet);
  let _energy = 100n;
  let _lastEnergyClaimed = 0n;

  [_lastEnergyClaimed, _energy] = await readContract(get(frameWalletConfig), {
    address: "0xC9aE8dA750AC66c686a748CBBdECd851abAc9362",
    chainId: baseSepolia.id, 
    functionName: "users",
    abi: [
      {
        type: "function",
        name: "users",
        inputs: [
          {
            name: "",
            type: "address",
            internalType: "address",
          },
        ],
        outputs: [
          {
            name: "lastEnergyClaimed",
            type: "uint256",
            internalType: "uint256",
          },
          {
            name: "energy",
            type: "uint256",
            internalType: "uint256",
          },
        ],
        stateMutability: "view",
      },
    ],
    args: [user],
  });

  console.log(_energy, _lastEnergyClaimed);
  userEnergy.set(_energy);
  userLastEnergyClaimed.set(_lastEnergyClaimed);
  if(_energy == 0n && _lastEnergyClaimed == 0n) {
    // User has no energy and has never claimed energy
    userEnergy.set(20n);
    userLastEnergyClaimed.set(BigInt(Date.now()));
  }

}
