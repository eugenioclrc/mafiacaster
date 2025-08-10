// import { browser } from '$app/environment'
import { http, createConfig } from "@wagmi/core";
import { base, foundry } from "wagmi/chains";

import { farcasterMiniApp as miniAppConnector } from "@farcaster/miniapp-wagmi-connector";
import {
  baseAccount,
  coinbaseWallet,
  injected,
  metaMask,
} from "wagmi/connectors";
import { PUBLIC_DEVMODE } from "$env/static/public";

export const supportedChains = PUBLIC_DEVMODE ? [foundry.id] : [base.id];

let _config: ReturnType<typeof createConfig> | null = null;

export const getConfig = () => {
  if (_config != null) return _config;
  if (PUBLIC_DEVMODE) {
    _config = createConfig({
      chains: [foundry],
      transports: {
        [foundry.id]: http(),
      },
      connectors: [injected(), metaMask()],
    });
  } else {
    _config = createConfig({
      chains: [base],
      transports: {
        [base.id]: http(),
      },
      connectors: [
        baseAccount(),
        coinbaseWallet(),
        miniAppConnector(),
        injected(),
        metaMask(),
      ],
    });
  }
  return _config;
};
