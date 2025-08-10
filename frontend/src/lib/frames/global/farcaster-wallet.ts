// import { browser } from '$app/environment'
import { http, createConfig } from "@wagmi/core";
import { baseSepolia } from "wagmi/chains";

import { farcasterMiniApp as miniAppConnector } from "@farcaster/miniapp-wagmi-connector";
import {
  baseAccount,
  coinbaseWallet,
  injected,
  metaMask,
} from "wagmi/connectors";
import { PUBLIC_DEVMODE } from "$env/static/public";

export const supportedChains = [baseSepolia.id];

let _config: ReturnType<typeof createConfig> | null = null;

export const getConfig = () => {
  if (_config != null) return _config;
    _config = createConfig({
      chains: [baseSepolia],
      transports: {
        [baseSepolia.id]: http(),
      },
      connectors: [
        baseAccount(),
        coinbaseWallet(),
        miniAppConnector(),
        injected(),
        metaMask(),
      ],
    });
  
  return _config;
}