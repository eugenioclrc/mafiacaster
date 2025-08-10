<script lang="ts">
	import { goto } from '$app/navigation';
	import sdk from '@farcaster/miniapp-sdk';

	function openProfile(e: Event) {
		e.preventDefault();
		sdk.actions.viewProfile({ fid: 16270 });
	}

	function openHome(e: Event) {
		e.preventDefault();
		goto('/');
	}
</script>

<header class="navbar bg-base-200 px-4 shadow-md">
	<div class="navbar-start">
		<button class="btn text-xl font-bold btn-ghost" on:click={openHome}>MiniApp</button>
	</div>
	<nav class="navbar-end space-x-2">
		<button on:click={openHome} class="btn btn-primary">Home</button>
		<button on:click={openProfile} class="btn btn-secondary">Follow&nbsp;Me</button>
	</nav>
</header>
