
<script>
  import "tailwindcss/tailwind.css";
  import { ethers } from 'ethers';
  import { onMount } from "svelte";

  let signer = null;

  let provider;
  let isConnected = false;
  let userAddress = '';
  onMount(() => {
        if (window.ethereum) {
            window.ethereum.on('accountsChanged', async (accounts) => {
                if (accounts.length > 0) {
                    userAddress = accounts[0];
                    isConnected = true;
                    await fetchLoyaltyPoints();
                } else {
                    userAddress = '';
                    isConnected = false;
                    loyaltyPoints = 0;
                }
            });
        }
    });
  async function connectWallet() {
        if (window.ethereum) {
            try {
                // Request account access
                await window.ethereum.request({ method: 'eth_requestAccounts' });

                // Initialize ethers provider and signer
                provider = new ethers.BrowserProvider(window.ethereum);
                signer = provider.getSigner();
                /* userAddress = await signer.getAddress(); */
                isConnected = true;

                contract = new ethers.Contract(contractAddress, contractABI, provider);

                console.log('Connected to MetaMask:', userAddress);
            } catch (error) {
                console.error('Failed to connect to MetaMask:', error);
            }
        } else {
            alert('MetaMask is not installed. Please install it to use this feature.');
        }
    }
</script>

<div class="min-h-screen flex flex-col">
  <header class="bg-base-100 shadow-lg">
    <div class="container mx-auto px-4 py-3 flex justify-between items-center">
      <a href="/" class="text-2xl font-bold text-primary">AI VTuber Market</a>
      <nav>
        <ul class="flex space-x-4">
          <li><a href="/marketplace" class="btn btn-ghost">Marketplace</a></li>
          <li><a href="/create" class="btn btn-ghost">Create</a></li>
          <li><a href="/profile" class="btn btn-ghost">Profile</a></li>
          {#if isConnected}
          <li><p>Connected!</p></li>

          {:else}
          <li><button class="btn btn-primary" on:click={connectWallet}>Connect Wallet</button></li>

          {/if}
          
        </ul>
      </nav>
    </div>
  </header>

  <main class="flex-grow">
    <slot />
  </main>

  <footer class="bg-neutral text-neutral-content">
    <div class="container mx-auto px-4 py-8">
      <div class="flex flex-wrap justify-between">
        <div class="w-full md:w-1/3 mb-6 md:mb-0">
          <h3 class="text-lg font-semibold mb-2">AI VTuber Market</h3>
          <p>Own, Trade, and Interact with Virtual Influencers</p>
        </div>
        <div class="w-full md:w-1/3 mb-6 md:mb-0">
          <h4 class="text-lg font-semibold mb-2">Quick Links</h4>
          <ul class="space-y-2">
            <li><a href="/about" class="hover:underline">About Us</a></li>
            <li><a href="/help" class="hover:underline">Help Center</a></li>
            <li><a href="/terms" class="hover:underline">Terms of Service</a></li>
            <li><a href="/privacy" class="hover:underline">Privacy Policy</a></li>
          </ul>
        </div>
        <div class="w-full md:w-1/3">
          <h4 class="text-lg font-semibold mb-2">Connect With Us</h4>
          <div class="flex space-x-4">
            <a href="#" class="btn btn-circle btn-outline">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current"><path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z"></path></svg>
            </a> 
            <a href="#" class="btn btn-circle btn-outline">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current"><path d="M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z"></path></svg>
            </a>
            <a href="#" class="btn btn-circle btn-outline">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current"><path d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z"></path></svg>
            </a>
          </div>
        </div>
      </div>
      <div class="mt-8 text-center">
        <p>Powered by EVM and ICP technologies</p>
      </div>
    </div>
  </footer>
</div>