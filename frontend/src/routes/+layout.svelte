<script lang="ts">
	import '../app.css';

	import sdk from '@farcaster/miniapp-sdk';

	import { onMount } from 'svelte';
	import { frameWalletConfig, isViewingFromFrame } from '$lib/stores/global/main';
	import OnlyViewUsingFrame from './OnlyViewUsingFrame.svelte';

	import { getConfig } from '$lib/frames/global/farcaster-wallet';
	import { page as SveltePage } from '$app/state';
	import { config } from '$lib/config';
	import { pageLoading } from "$lib/stores/global/main";
	import { isWalletReady, userWallet } from '$lib/stores/global/main';

	import { generateURLFCFrameEmbed } from '$lib/frames/global/client/fc-frame-v2';

		import {
		watchConnections,
		getAccount,
		connect,
	} from '@wagmi/core';
	import { baseAccount, coinbaseWallet, metaMask, injected } from 'wagmi/connectors';
	import { farcasterMiniApp as miniAppConnector } from '@farcaster/miniapp-wagmi-connector';

	const ogImage = `${config.resolvedBaseUrl}/logo.png`;
	const pageUrl = SveltePage.url.href.replace('http:', 'https:');
	const pageTitle = 'SveleteKit starter Mini App';
	const pageDescription =
		'Mini app starter for SvelteKit using Farcaster, 2 demo apps are included';

	onMount(async () => {
		const context = await sdk.context;

		sdk.on('miniAppAdded', ({ notificationDetails: details }) => {
			console.log(`miniAppAdded${details ? ', notifications enabled' : ''}`);
			if (details) {
				console.log('notificationDetails', details);
			}
		});

		sdk.on('miniAppAddRejected', ({ reason }) => {
			console.log(`miniAppAddRejected, reason ${reason}`);
		});

		sdk.on('miniAppRemoved', () => {
			console.log('miniAppRemoved');
		});

		sdk.on('notificationsEnabled', ({ notificationDetails: details }) => {
			console.log('notificationsEnabled');
			console.log('notificationDetails', details);
		});

		sdk.on('notificationsDisabled', () => {
			console.log('notificationsDisabled');
		});

		sdk.on('primaryButtonClicked', () => {
			console.log('primaryButtonClicked');
		});

		sdk.actions.ready();

		if ((context?.user?.fid || 0) > 0) {
			$isViewingFromFrame = true;
		}
		$frameWalletConfig = getConfig();
		
		let unwatch;
		if (getAccount($frameWalletConfig)?.address) {
			$isWalletReady = true;
			$userWallet = getAccount($frameWalletConfig)?.address || null;
		} else {
			unwatch = watchConnections($frameWalletConfig, {
				onChange() {
					if (getAccount($frameWalletConfig)?.address) {
						$isWalletReady = true;
						$userWallet = getAccount($frameWalletConfig)?.address || null;
					}
				}
			});
		}

		if (unwatch) unwatch();
	});

	let { children } = $props();

	async function doConnect(connectionType: string) {
		if (connectionType == 'farcaster') {
			const result = await connect($frameWalletConfig, { connector: miniAppConnector() });
		} else if(connectionType == 'baseWallet') {
			const result = await connect($frameWalletConfig, { connector: baseAccount() });
		} else if(connectionType == 'baseCDP') {
			const result = await connect($frameWalletConfig, { connector: coinbaseWallet() });
		} else if(connectionType == 'injected') {
			try {
				await connect($frameWalletConfig, { connector: injected() });
			} catch(error) {
				await connect($frameWalletConfig, { connector: metaMask() });
			}
		}

		//chainId = getChainId($frameWalletConfig);
		$userWallet = getAccount($frameWalletConfig)?.address || null;
		if($userWallet) {
			$isWalletReady = true;
		}
	}
	
</script>

<svelte:head>
	<title>{pageTitle}</title>
	<meta name="description" content={pageDescription} />
	<meta property="og:title" content={pageTitle} />
	<meta property="og:description" content={pageDescription} />
	<meta property="og:type" content="website" />
	<meta property="og:url" content={`${pageUrl}`} />
	<meta property="og:image" content={ogImage} />

	<meta
		name="fc:miniapp"
		content={generateURLFCFrameEmbed({
			url: pageUrl,
			featureImage: ogImage
		})}
	/>
</svelte:head>

<div class="mx-auto min-h-screen max-w-md bg-base-200 text-base-content">

	{#if $pageLoading}
		<OnlyViewUsingFrame />
	{:else if !$isWalletReady || !$userWallet}
<div class="text-center pt-8">
		<h1 class="text-3xl font-bold">MafiaCaster</h1>
	</div>


<div class="card  p-4  mt-10">
	<h2 class="mb-2 text-lg font-semibold">Pick your wallet</h2>

	{#if $isViewingFromFrame}

		<button class="btn btn-primary" onclick={() => sdk.actions.addMiniApp()}>Add Mini App</button>
		<button class="btn btn-primary my-2" onclick={() => doConnect('farcaster')}>Farcaster</button>
		<button class="btn btn-primary my-2" onclick={() => doConnect('baseWallet')}>Base Wallet</button>
	{:else}
		<button class="btn btn-primary my-2" onclick={() => doConnect('baseWallet')}>Base Wallet</button>
		<!-- <button class="btn btn-primary my-2" onclick={() => doConnect('baseCDP')}>Base CDP</button> -->
		<button class="btn btn-primary my-2" onclick={() => doConnect('injected')}>Metamsk</button>
	{/if}
</div>

	{:else}
		{@render children()}
	{/if}
</div>
