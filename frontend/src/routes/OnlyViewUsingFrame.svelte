<script lang="ts">
	import { onMount } from 'svelte';
	import NotFrameContextError from './NotFrameContextError.svelte';
	import { pageLoading} from "$lib/stores/global/main";

	const maxLoadingTime = 1800;
	let loadingTime = 0;

	onMount(() => {
		const interval = setInterval(() => {
			loadingTime += 100;
			if (loadingTime >= maxLoadingTime) {
				clearInterval(interval);
				$pageLoading = false;
			}
		}, 100);
	});
</script>

<div class="mt-8 flex h-96 flex-col items-center justify-center">
		<div class="flex flex-col items-center gap-4">
			<span class="loading loading-lg loading-ring text-primary"></span>
			<span class="text-sm text-gray-500">Waiting for context...</span>
		</div>
</div>
