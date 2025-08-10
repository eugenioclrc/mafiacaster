<script lang="ts">
	import StatsHead from './StatsHead.svelte';
import gameAbi from '$lib/abi/game.json';
  	import { getConfig } from '$lib/frames/global/farcaster-wallet';
import { isWalletReady,frameWalletConfig , userWallet} from '$lib/stores/global/main';
  import {waitForTransactionReceipt, writeContract } from "@wagmi/core";
  import { loadUserData } from '$lib/stores/global/main';
import { parseEventLogs } from 'viem'
  import { baseSepolia } from 'viem/chains';


  $effect(() => {
	if ($isWalletReady) loadUserData();
  });
  
  let working = $state(false);
  let selectedMission = $state(null);

 async function doJob() {

  working = true;
  selectedMission = null;

  if(!$isWalletReady) {
	  alert("Please connect your wallet first");
	  return;
  }



const hash = await writeContract(getConfig(), {
  to: '0xC9aE8dA750AC66c686a748CBBdECd851abAc9362',
    chainId: baseSepolia.id, 
	abi: gameAbi,
	functionName: 'doMission',
  args: [1n],
});
console.log(hash);
const transactionReceipt = await  waitForTransactionReceipt(getConfig(), {
  hash,
})

loadUserData();

  const decoded = parseEventLogs({
    abi: gameAbi,
    logs: transactionReceipt.logs,              // los logs crudos del receipt
    // opcional: filtrar por address o por nombre de evento
    // eventName: 'MissionDone',
    // strict: false, // si querés que ignore logs que no machean (default)
  })

  if(decoded.filter((log) => log.eventName === 'DoMission')[0].args.hasWon) {
	console.log("dad")
	jobs[0].progress += 10;
	jobs[0].progress = Math.min(jobs[0].progress, 100);
	jobs = [...jobs];
  };

 }

	// --- Mock game state (replace with real data later) ---
	type Job = {
		id: string;
		title: string;
		city: string;
		requires: { level?: number; energy?: number; item?: string };
		rewards: { cash: number; xp: number };
		progress: number; // 0..100
		locked?: boolean;
	};

	const profile = {
		level: 3,
		hp: { current: 110, max: 110 },
		energy: { current: 21, max: 21 },
		ammo: { current: 10, max: 3 },
		cash: 4928, // in $
		coins: 17,
		xp: { current: 0, max: 18 }
	};

	let activeCity = 'ny';

	let jobs: Job[] = $state([
		{
			id: 'mug',
			title: 'Mug someone',
			city: 'ny',
			requires: { energy: 1 },
			rewards: { cash: 200, xp: 1 },
			progress: 0
		},
		{
			id: 'steal-car',
			title: 'Steal a car',
			city: 'ny',
			requires: { level: 5, energy: 3, item: 'Baseball bat' },
			rewards: { cash: 1500, xp: 4 },
			progress: 0,
			locked: true
		},
		{
			id: 'deal-drugs',
			title: 'Deal some drugs',
			city: 'ny',
			requires: { level: 10, energy: 5, item: 'Pistol' },
			rewards: { cash: 4000, xp: 7 },
			progress: 0,
			locked: true
		}
	]);

	const cityJobs = (id: string) => jobs.filter((j) => j.city === id);
</script>

<!-- Page container -->

	<!-- Pixel-perfect header recreation -->
	<StatsHead {profile} />

	<!-- City selector row (pixel-perfect) -->
	<section
		class="border-t border-b border-black bg-[#1a1a1a] bg-gradient-to-b from-[#2b2b2b] to-[#111] px-3 pt-3 pb-2"
	>
		<div class="mx-auto grid max-w-3xl grid-cols-3 gap-3">
			<!-- Active: New York -->
			<button
				class="relative overflow-hidden rounded-xl border-2 border-[#ffd13a] bg-[#2b2b2b] shadow-[inset_0_2px_0_rgba(255,255,255,.15),0_2px_0_rgba(0,0,0,.6)]"
			>
				<img
					src="./1.jpg"
					alt="New York"
					class="filter h-24 w-full object-cover opacity-70 contrast-50 grayscale"
				/>
				<!-- title + progress -->
				<div class="absolute inset-x-0 bottom-0 p-2">
					<div
						class="text-left text-[18px] font-semibold text-[#ffd13a] drop-shadow-[0_1px_0_rgba(0,0,0,.9)]"
					>
						New York
					</div>
					<div class="mt-1 flex items-center gap-2">
						<div class="h-2 flex-1 rounded-full bg-black/70">
							<div class="h-2 w-[2%] rounded-full bg-[#444]"></div>
						</div>
						<div class="text-xs text-white/80">2%</div>
					</div>
				</div>
			</button>

			<!-- Locked: Chicago -->
			<button
				class="relative overflow-hidden rounded-xl border-2 border-[#6b6b6b] bg-[#2b2b2b]/80 shadow-[inset_0_2px_0_rgba(255,255,255,.08),0_2px_0_rgba(0,0,0,.6)]"
			>
				<img
					src="https://placehold.co/300x180/0b0f14/8a8a8a?text=Chicago"
					alt="Chicago"
					class="h-24 w-full object-cover opacity-60"
				/>
				<div class="absolute inset-0 bg-black/30"></div>
				<div class="absolute top-2 right-2 text-lg text-white/90">🔒</div>
				<div class="absolute bottom-2 left-2 text-[18px] font-semibold text-white/60"></div>
			</button>

			<!-- Locked: London -->
			<button
				class="relative overflow-hidden rounded-xl border-2 border-[#6b6b6b] bg-[#2b2b2b]/80 shadow-[inset_0_2px_0_rgba(255,255,255,.08),0_2px_0_rgba(0,0,0,.6)]"
			>
				<img
					src="https://placehold.co/300x180/0b0f14/8a8a8a?text=London"
					alt="London"
					class="h-24 w-full object-cover opacity-60"
				/>
				<div class="absolute inset-0 bg-black/30"></div>
				<div class="absolute top-2 right-2 text-lg text-white/90">🔒</div>
				<div class="absolute bottom-2 left-2 text-[18px] font-semibold text-white/60"></div>
			</button>
		</div>

		<!-- City progress banner -->

		<div class="mx-auto mt-3 max-w-3xl">
			<div
				class="relative rounded-xl border-2 border-black/60 bg-[#2c2c2c] p-2 shadow-[inset_0_2px_0_rgba(255,255,255,.05),0_3px_0_rgba(0,0,0,.7)]"
			>
				<!-- left icon tile -->
				
				<!-- blue notch -->
				<div
					class="absolute top-2.5 mt-0.5 h-8.5 ml-1 rounded w-[39px] bg-[#3b8ed8] shadow-[inset_0_0_3px_rgba(0,0,0,.6)]"
				></div>
				<!-- pill text -->
				<div
					class="rounded-lg border border-black/70 bg-[#111] px-4 py-2 text-center shadow-[inset_0_1px_0_rgba(255,255,255,.05)]"
				>
					<span class="z-10 relative font-semibold tracking-wide text-white">NEW YORK:</span>
					<span class="z-10 relative font-extrabold tracking-wide text-[#ffd13a]"> 2% JOBS COMPLETED</span>
				</div>
			</div>
		</div>
	</section>

	<!-- Jobs list -->
	<div class="mx-auto grid max-w-4xl gap-4 p-3">
		{#each cityJobs(activeCity) as job}
			<div class="card bg-base-100 shadow-lg">
				<div class="card-body">
					<div class="flex items-start justify-between">
						<h2 class="card-title">{job.title}</h2>
						<div class="rating-sm rating">
							<input type="radio" class="mask mask-star" disabled />
							<input type="radio" class="mask mask-star" disabled />
							<input type="radio" class="mask mask-star" disabled />
						</div>
					</div>

					<div class="grid gap-4 md:grid-cols-2">
						<div>
							<div class="mb-2 text-sm opacity-70">Requires:</div>
							<div class="flex flex-wrap gap-2">
								{#if job.requires.energy}
									<div class="badge gap-1 badge-outline badge-warning">
										⚡ {job.requires.energy}
									</div>
								{/if}
								{#if job.requires.item}
									<div class="badge gap-2 badge-outline"><span>🪖</span>{job.requires.item}</div>
								{/if}
								{#if job.requires.level}
									<div class="badge badge-outline badge-error">
										Unlock at Level {job.requires.level}
									</div>
								{/if}
							</div>
						</div>
						<div>
							<div class="mb-2 text-sm opacity-70">Rewards:</div>
							<div class="flex items-center gap-3">
								<div class="badge gap-1 badge-outline badge-success">
									💵 {job.rewards.cash.toLocaleString()}
								</div>
								<div class="badge gap-1 badge-outline badge-info">🧠 {job.rewards.xp} XP</div>
							</div>
						</div>
					</div>

					<div class="mt-4 flex items-center gap-3">
						<div class="flex-1">
							<div class="mb-1 text-xs">{job.progress}% COMPLETE</div>
							<progress class="progress w-full" value={job.progress} max="100"></progress>
						</div>
						{#if job.locked}
							<button class="btn-disabled btn btn-lg">LOCKED</button>
						{:else}
							<button class="btn gap-2 btn-lg btn-accent" onclick={doJob}>
								DO JOB!
								<span class="badge badge-ghost badge-warning">⚡ {job.requires.energy ?? 1}</span>
							</button>
						{/if}
					</div>
				</div>
			</div>
		{/each}
	</div>




<!-- Open the modal using ID.showModal() method -->
<dialog id="modalJob" class="modal">
  <div class="modal-box">
    <h3 class="text-lg font-bold">Hello!</h3>
    <p class="py-4">Your Connected wallet is {$userWallet}</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn btn-primary">Redo job</button>

        <!-- if there is a button in form, it will close the modal -->
        <button class="btn">Close modal</button>
      </form>
    </div>
  </div>
</dialog>