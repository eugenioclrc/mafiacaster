<script lang="ts">
	export let profile = {
		hp: {},
		energy: {}
	};

	import { userWallet ,frameWalletConfig, isWalletReady, userEnergy} from '$lib/stores/global/main';

	import { disconnect } from 'wagmi/actions';

	async function doDisconnect() {
		try {
			const result = await disconnect($frameWalletConfig);
			console.log(result);
		} catch (error) {
			console.log('disconnect error, seems to be not working');
			console.error(error);
		}
		$userWallet = null;
		$isWalletReady = false;
	}

</script>

<div
	class="w-full border-b-2 border-slate-800 bg-gradient-to-b from-slate-500 to-slate-700 shadow-inner"
>
	<div class="flex items-center justify-between px-2 py-1">
		<button class="btn btn-circle btn-ghost">
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-6 w-6 fill-current text-white"
				><path d="M20 11H7.83l5.59-5.59L12 4 4 12l8 8 1.41-1.41L7.83 13H20v-2z" /></svg
			>
		</button>
		<div class="flex items-center gap-1 text-lg font-bold tracking-widest text-white">
			JOBS
			
		</div>
		{$userWallet?.substring(0,5)}...{$userWallet?.substr(-3)}
		<button class="p-1 btn-circle btn-ghost btn" on:click={my_modal_1.showModal()}>
			<svg height="24px" width="24px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 60.671 60.671" xml:space="preserve" fill="#fff" stroke="#fff"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g> <g> <ellipse style="fill:#fff;" cx="30.336" cy="12.097" rx="11.997" ry="12.097"></ellipse> <path style="fill:#fff;" d="M35.64,30.079H25.031c-7.021,0-12.714,5.739-12.714,12.821v17.771h36.037V42.9 C48.354,35.818,42.661,30.079,35.64,30.079z"></path> </g> </g> </g></svg>
			<!--

			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-6 w-6 fill-current text-white"
				><path
					d="M12 2a7 7 0 0 0-7 7v3.764l-1.553 3.88A1 1 0 0 0 4.368 18H19.63a1 1 0 0 0 .92-1.356L19 12.764V9a7 7 0 0 0-7-7zm0 20a3 3 0 0 0 2.995-2.824L15 19H9a3 3 0 0 0 2.824 2.995z"
				/></svg
			>
		-->
		</button>
	</div>

	<!-- Stats Row -->
	<div class="flex items-center gap-1 px-2 pb-1">
		<div class="flex w-full items-center justify-around gap-4 rounded-sm bg-slate-800 px-2 py-1">
			<div class="flex items-center gap-1 text-white">
				<span class="text-red-500">❤</span>{profile.hp.current}/{profile.hp.max}
			</div>
			<div class="flex items-center gap-1 text-yellow-400">
				⚡{$userEnergy}/100
			</div>
			<div class="flex items-center gap-1 text-green-400">💵${profile.cash}k</div>
		</div>
	</div>

	<!-- Level and XP -->
	<div class="flex items-center justify-between px-2 pb-1">
		<div class="text-white">Lvl: {profile.level}</div>
		<div class="flex items-center gap-2">
			<progress
				class="progress h-2 w-32 progress-success"
				value={profile.xp.current}
				max={profile.xp.max}
			></progress>
			<span class="font-bold text-green-400">{profile.xp.current}/{profile.xp.max} XP</span>
		</div>
	</div>
</div>


<!-- Open the modal using ID.showModal() method -->
<dialog id="my_modal_1" class="modal">
  <div class="modal-box">
    <h3 class="text-lg font-bold">Hello!</h3>
    <p class="py-4">Your Connected wallet is {$userWallet}</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn btn-error" on:click={doDisconnect}>Disconnect</button>

        <!-- if there is a button in form, it will close the modal -->
        <button class="btn">Close modal</button>
      </form>
    </div>
  </div>
</dialog>