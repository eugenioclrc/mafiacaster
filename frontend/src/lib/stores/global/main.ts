import { writable } from 'svelte/store';
import type { WalletConfig } from '$lib/types/frame-sdk';


export const pageLoading = writable(true);
export const navigationLoading = writable(false);
export const frameWalletConfig = writable<WalletConfig>(null as unknown as WalletConfig);
export const isViewingFromFrame = writable(false);
export const isWalletReady = writable(false);
export const userWallet = writable<string | null>(null);
