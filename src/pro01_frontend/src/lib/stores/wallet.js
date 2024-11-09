// src/lib/stores/wallet.js
import { writable } from 'svelte/store';
import { ethers } from 'ethers';

// Store for provider and signer
export const provider = writable(null);
export const signer = writable(null);

// Function to connect to MetaMask
export async function connectMetaMask() {
  if (window.ethereum == null) {
    console.log("MetaMask not installed; using read-only defaults");
    provider.set(ethers.getDefaultProvider());
  } else {
    const browserProvider = new ethers.BrowserProvider(window.ethereum);
    provider.set(browserProvider);
    signer.set(await browserProvider.getSigner());
  }
}
