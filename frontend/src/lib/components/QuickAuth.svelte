<script lang="ts">
	import { sdk, SignIn as SignInCore } from '@farcaster/miniapp-sdk';
	import { jwtDecode } from 'jwt-decode';
	import { createEventDispatcher } from 'svelte';

	export let token: string | null = null;
	export let setToken: (val: string | null) => void;

	const dispatch = createEventDispatcher();

	let signingIn = false;
	let signInFailure: string | null = null;

	const handleSignIn = async () => {
		try {
			signingIn = true;
			signInFailure = null;

			const result = await sdk.quickAuth.getToken();
			token = result.token;
			setToken?.(token);

			dispatch('signedin', { token });

			// Example request
			await fetch('/api/me', {
				headers: { Authorization: `Bearer ${token}` }
			});
		} catch (e) {
			if (e instanceof SignInCore.RejectedByUser) {
				signInFailure = '❌ Rejected by user';
			} else {
				signInFailure = '❌ Unknown error';
			}
		} finally {
			signingIn = false;
		}
	};

	const handleSignOut = () => {
		token = null;
		setToken?.(null);
		dispatch('signout');
	};
</script>

<div class="space-y-2">
	{#if !token}
		<button class="btn w-full btn-primary" on:click={handleSignIn} disabled={signingIn}>
			{signingIn ? 'Signing in...' : 'Sign In'}
		</button>
	{:else}
		<button class="btn w-full btn-error" on:click={handleSignOut}> Sign Out </button>

		<div class="collapse-arrow collapse rounded-box border border-base-300 bg-base-200">
			<input type="checkbox" />
			<div class="collapse-title text-sm font-medium">📄 Raw JWT</div>
			<div class="collapse-content">
				<pre class="text-xs break-words whitespace-pre-wrap">{token}</pre>
			</div>
		</div>

		<div class="collapse-arrow collapse rounded-box border border-base-300 bg-base-200">
			<input type="checkbox" />
			<div class="collapse-title text-sm font-medium">🧠 Decoded JWT</div>
			<div class="collapse-content">
				<pre class="text-xs break-words whitespace-pre-wrap">{JSON.stringify(
						jwtDecode(token),
						null,
						2
					)}</pre>
			</div>
		</div>
	{/if}

	{#if signInFailure}
		<div class="alert alert-error text-xs">{signInFailure}</div>
	{/if}
</div>
