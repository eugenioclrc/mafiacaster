<script lang="ts">
	import sdk from '@farcaster/miniapp-sdk';

	let result: any = $state(null);

	async function compose() {
		result = await sdk.actions.composeCast({
			text: 'Hello from Demo Mini App',
			embeds: ['https://farcaster-miniapp-sveltekit-starter.vercel.app/']
		});
	}
</script>

<div class="card bg-base-100 p-4 shadow-md">
	<h2 class="mb-2 text-lg font-semibold">📝 Cast</h2>
	<div class="rounded bg-neutral px-3 py-1 font-mono text-sm text-white">
		sdk.actions.composeCast( ... )
	</div>

	<button
		class="btn w-full bg-purple-500 font-bold text-white hover:bg-purple-600"
		onclick={compose}
	>
		Compose Cast
	</button>

	{#if result?.cast?.hash}
		<div class="alert alert-info text-xs">
			Cast Hash: {result.cast.hash}
		</div>
	{/if}
</div>
