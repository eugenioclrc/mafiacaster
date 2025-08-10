import { CdpClient } from "@coinbase/cdp-sdk";
import "dotenv/config";

import { http, createPublicClient, parseEther } from "viem";
import { baseSepolia } from "viem/chains";
import dotenv from "dotenv";

dotenv.config();

const publicClient = createPublicClient({
  chain: baseSepolia,
  transport: http(),
});

const cdp = new CdpClient();

// Get an existing account
const account = await cdp.evm.getOrCreateAccount({
  name: "paymaster",
});
console.log(`Original account name: ${account.name}`);

console.log(account.address);

const faucetResponse = await cdp.evm.requestFaucet({
  address: account.address,
  network: "base-sepolia",
  token: "eth",
});
console.log(
  `Requested funds from ETH faucet: https://sepolia.basescan.org/tx/${faucetResponse.transactionHash}`,
);

// Step 3: Use the v2 Server Wallet to send a transaction.
const transactionResult = await cdp.evm.sendTransaction({
  address: account.address,
  transaction: {
    data: "0xdeadbeef",
    to: "0x0000000000000000000000000000000000000000",
    value: parseEther("0.000001"),
  },
  network: "base-sepolia",
});

// Step 4: Wait for the transaction to be confirmed
const txReceipt = await publicClient.waitForTransactionReceipt({
  hash: transactionResult.transactionHash,
});
