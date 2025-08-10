<script lang="ts">
	const job = {
		title: 'Mug someone',
		medalIcon: '🏅',
		progress: 40,
		rewards: { cash: 214, xp: 1, gp: 835 },
		requires: { energy: 1 }
	};
</script>

<div class=" mx-auto min-h-screen max-w-md bg-base-200 text-base-content">
	<!-- Job detail card recreation -->
	<div
		class="relative flex min-h-screen flex-col justify-between bg-[url('https://placehold.co/600x800/0b0f14/ffffff?text=Alley+BG')] bg-cover bg-center"
	>
		<!-- Top info -->
		<div class="p-4">
			<div class="mb-2 flex items-center gap-3">
				<div
					class="flex h-12 w-12 items-center justify-center overflow-hidden rounded border border-black bg-gray-700 text-2xl"
				>
					{job.medalIcon}
				</div>
				<h1 class="text-2xl font-semibold text-white drop-shadow">{job.title}</h1>
			</div>
			<div class="flex items-center gap-3">
				<!-- Stars -->
				<div
					class="flex h-6 flex-1 items-center rounded border border-black/50 bg-gradient-to-b from-[#3a6aa5] to-[#1f3d5c] px-2 shadow"
				>
					<div class="mr-2 flex gap-1">
						<span class="text-xl">⭐</span>
						<span class="text-xl opacity-50">⭐</span>
						<span class="text-xl opacity-50">⭐</span>
					</div>
					<span class="text-sm font-medium text-white/90">{job.progress}% Complete</span>
				</div>
			</div>
		</div>

		<!-- Rewards & Requires -->
		<div class="mb-4 flex justify-between px-6 text-white">
			<div>
				<div class="text-sm opacity-80">Rewards:</div>
				<div class="mt-1 flex flex-col gap-1">
					<div class="flex items-center gap-2"><span>💵</span> <span>200+</span></div>
					<div class="flex items-center gap-2"><span>🧠</span> <span>1 XP</span></div>
				</div>
			</div>
			<div>
				<div class="text-sm opacity-80">Requires:</div>
				<div class="mt-1 flex flex-col gap-1">
					<div class="flex items-center gap-2"><span>⚡</span> <span>1</span></div>
				</div>
			</div>
		</div>

		<!-- Bottom reward panel -->
		<div>
			<div
				class="flex justify-around border-t border-black bg-green-700/90 py-3 text-lg font-semibold text-white"
			>
				<div class="flex items-center gap-2">💵 +${job.rewards.cash}</div>
				<div class="flex items-center gap-2 text-orange-300">⚡ - {job.requires.energy} Energy</div>
				<div class="flex items-center gap-2">🧠 +{job.rewards.xp} XP</div>
				<div class="flex items-center gap-2">🪙 +{job.rewards.gp} GP</div>
			</div>
			<button class="w-full bg-red-600 py-3 text-xl font-bold text-white hover:bg-red-700"
				>Do Job</button
			>
		</div>
	</div>

	<section
		class="relative mx-auto mt-4 max-w-md overflow-hidden rounded-xl border border-black/60 shadow-[0_6px_0_rgba(0,0,0,.6)]"
		style="background:#0b0f14"
	>
		<!-- Background image -->
		<div class="relative p-4">
			<!-- Title row -->
			<div class="flex items-start gap-3">
				<div
					class="flex h-16 w-16 items-center justify-center rounded-lg border-2 border-white/20 bg-gradient-to-b from-[#c4ccd6] to-[#6e7a87] shadow-[inset_0_2px_0_rgba(255,255,255,.25)]"
				>
					<span class="text-2xl">🎖️</span>
				</div>
				<div class="flex-1">
					<h1 class="text-3xl font-semibold text-white drop-shadow-[0_1px_0_rgba(0,0,0,.9)]">
						{job.title}
					</h1>

					<!-- Blue star progress pill -->
					<div
						class="relative mt-2 h-10 max-w-[420px] overflow-hidden rounded-lg border border-black/70 bg-gradient-to-b from-[#4e8fd1] to-[#2f6fb7] shadow-[inset_0_1px_0_rgba(255,255,255,.2)]"
					>
						<div
							class="absolute inset-y-0 left-0 bg-black/30"
							style={`width:${100 - job.progressPct}%`}
						></div>
						<div class="absolute inset-y-0 right-0 w-1 bg-black/60"></div>
						<div class="absolute inset-0 flex items-center gap-2 px-3">
							<div class="rating-md rating">
								<input class="mask bg-black/30 mask-star-2" disabled />
								<input class="mask bg-black/30 mask-star-2" disabled />
								<input class="mask bg-black/70 mask-star-2" disabled />
							</div>
							<div class="ml-auto text-lg font-semibold text-white">
								{job.progressPct}% Complete
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Rewards / Requires columns -->
			<div class="mt-8 grid max-w-[520px] grid-cols-2 gap-6">
				<div>
					<div class="font-bold tracking-wide text-gray-300">Rewards:</div>
					<div class="mt-3 space-y-2 text-white">
						<div class="flex items-center gap-2">
							<span>💵</span><span class="font-semibold text-green-300">200+</span>
						</div>
						<div class="flex items-center gap-2">
							<span>🧠</span><span class="font-semibold text-green-300">1 XP</span>
						</div>
					</div>
				</div>
				<div>
					<div class="font-bold tracking-wide text-gray-300">Requires:</div>
					<div class="mt-3 space-y-2 text-white">
						<div class="flex items-center gap-2">
							<span>⚡</span><span class="font-semibold">{job.requires.energy}</span>
						</div>
					</div>
				</div>
			</div>

			<!-- Bottom green panel -->
			<div class="absolute right-0 bottom-20 left-0 px-4">
				<div
					class="mx-auto max-w-[720px] rounded-xl border-2 border-black/60 bg-gradient-to-b from-[#3f7d26] to-[#2e5d1c] px-5 py-4 text-white shadow-[inset_0_1px_0_rgba(255,255,255,.12),0_4px_0_rgba(0,0,0,.6)]"
				>
					<div class="grid grid-cols-2 gap-6 text-lg">
						<div class="space-y-2">
							<div class="flex items-center gap-2">
								<span>💵</span><span class="font-bold text-green-200">+${job.rewards.cash}</span>
							</div>
							<div class="flex items-center gap-2">
								<span>🧠</span><span class="font-bold text-green-200">+{job.rewards.xp} XP</span>
							</div>
						</div>
						<div class="space-y-2">
							<div class="flex items-center justify-start gap-2 md:justify-end">
								<span>⚡</span><span class="font-bold text-orange-300">- 1 Energy</span>
							</div>
							<div class="flex items-center justify-start gap-2 md:justify-end">
								<span>🟣</span><span class="font-bold text-gray-200">+{job.rewards.gp} GP</span>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Big red button -->
			<div class="absolute right-0 bottom-0 left-0 p-4">
				<button
					class="btn h-14 w-full rounded-xl text-2xl font-semibold shadow-[0_4px_0_rgba(0,0,0,.6)] btn-error"
					>Do Job</button
				>
			</div>
		</div>
	</section>
</div>
