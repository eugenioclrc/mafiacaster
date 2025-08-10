<script lang="ts">
	import Header from './Header.svelte';

	import QuickAuth from '$lib/components/QuickAuth.svelte';
	import ComposeCastAction from '$lib/components/ComposeCastAction.svelte';
	import sdk from '@farcaster/miniapp-sdk';
	import FarcasterWalletConnect from '$lib/components/FarcasterWalletConnect.svelte';

	let token: string | null = $state(null);
	let isContextOpen = $state(false);
	let selectedUrl: string = $state('');
	const toggleContext = () => {
		isContextOpen = !isContextOpen;
	};

	let context: any = $state(null);
	$effect(() => {
		if (sdk.context) {
			sdk.context.then((ctx) => {
				console.log('ctx', ctx);
				context = ctx;
			});
		}
	});

	let fid: number = $state(16270);
</script>

<Header />

<div class="mx-auto max-w-md space-y-6 p-4">
	<div class="text-center">
		<h1 class="text-3xl font-bold">🧪 Farcaster MiniApp</h1>
	</div>

	<div class="collapse-arrow collapse bg-base-200">
		<input type="checkbox" bind:checked={isContextOpen} />
		<div class="collapse-title font-medium">Client Context</div>
		<div class="collapse-content">
			<pre class="text-xs break-words whitespace-pre-wrap">{JSON.stringify(
					context,
					(_, v) => (typeof v === 'bigint' ? v.toString() : v),
					2
				)}</pre>
		</div>
	</div>
</div>
<div class="mx-auto max-w-md p-4">
	<h1 class="mb-2 text-lg font-semibold">Actions</h1>
</div>
<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">🔑 Quick Auth</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">sdk.quickAuth()</div>
	<QuickAuth setToken={(t) => (token = t)} />
</div>

<ComposeCastAction />

<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">📝 Cast</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">
		sdk.actions.openUrl( URL )
	</div>
	<button
		class="btn mt-0.5 btn-primary"
		onclick={() => sdk.actions.openUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ')}
		>Open URL</button
	>
	<button
		class="btn mt-0.5 btn-primary"
		onclick={() => sdk.actions.openUrl('https://warpcast.com/~/compose')}>Open Warpcast URL</button
	>
</div>

<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">👤 View Profile</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">
		sdk.actions.viewProfile(&#123; fid: FID &#125;)
	</div>
	<input type="number" bind:value={fid} class="input-bordered input mt-0.5 w-full max-w-xs" />
	<button class="btn btn-primary" onclick={() => sdk.actions.viewProfile({ fid: fid })}
		>View Profile</button
	>
</div>

<!-- sdk.actions.addMiniApp -->
<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">🔥 Add Mini App</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">
		sdk.actions.addMiniApp()
	</div>
	<button class="btn btn-primary" onclick={() => sdk.actions.addMiniApp()}>Add Mini App</button>
</div>

<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">📝 Cast</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">sdk.actions.close()</div>
	<button class="btn btn-primary" onclick={() => sdk.actions.close()}>Close</button>
</div>

<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">🔍 Open Mini App URL</h2>
	<select class="select-bordered select mt-0.5 w-full max-w-xs" bind:value={selectedUrl}>
		{#each [{ label: 'Bountycaster (Embed)', value: 'https://www.bountycaster.xyz/bounty/0x392626b092e05955c11c41c5df8e2fb8003ece78' }, { label: 'Demo MiniApp', value: 'https://farcaster.xyz/miniapps/AEk2134ULE4Y/sveletekit-starter-mini-app' }, { label: 'Invalid URL', value: 'https://swizec.com/' }] as option}
			<option value={option.value}>{option.label}</option>
		{/each}
	</select>
	<button
		class="btn mt-0.5 btn-primary"
		onclick={async () => {
			try {
				await sdk.actions.openMiniApp({ url: selectedUrl });
			} catch (error) {
				console.error(error);
			}
		}}>Open Mini App</button
	>
</div>

<!-- wallet connect-->
<FarcasterWalletConnect />
