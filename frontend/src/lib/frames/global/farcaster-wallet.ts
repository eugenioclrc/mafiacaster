// import { browser } from '$app/environment'
import { http, createConfig } from '@wagmi/core';
import { base } from 'wagmi/chains';

import { farcasterMiniApp as miniAppConnector } from '@farcaster/miniapp-wagmi-connector';
import { baseAccount, coinbaseWallet, injected } from 'wagmi/connectors';

export const supportedChains = [base.id];

let _config: ReturnType<typeof createConfig> | null = null;

export const getConfig = () => {
	if (_config != null) return _config;
	_config = createConfig({
		chains: [base],
		transports: {
			[base.id]: http()
		},
		connectors: [baseAccount(), coinbaseWallet(), miniAppConnector(), injected()]
	});
	return _config;
};
