<script>
  import { onMount } from 'svelte';
  import { ethers } from 'ethers';

  let featuredVTubers = [
    { id: 1, name: 'Aiko', image: '/placeholder.svg?height=300&width=300', traits: ['Cheerful', 'Energetic'] },
    { id: 2, name: 'Neo', image: '/placeholder.svg?height=300&width=300', traits: ['Cool', 'Mysterious'] },
    { id: 3, name: 'Luna', image: '/placeholder.svg?height=300&width=300', traits: ['Elegant', 'Calm'] },
  ];

  let currentVTuber = 0;

  onMount(() => {
    const interval = setInterval(() => {
      currentVTuber = (currentVTuber + 1) % featuredVTubers.length;
    }, 5000);

    return () => clearInterval(interval);
  });

  let signer = null;

  let provider;
  async function connect() {

    if (window.ethereum == null) {

    // If MetaMask is not installed, we use the default provider,
    // which is backed by a variety of third-party services (such
    // as INFURA). They do not have private keys installed,
    // so they only have read-only access
    console.log("MetaMask not installed; using read-only defaults")
    provider = ethers.getDefaultProvider()

    } else {

    // Connect to the MetaMask EIP-1193 object. This is a standard
    // protocol that allows Ethers access to make all read-only
    // requests through MetaMask.
    provider = new ethers.BrowserProvider(window.ethereum)

    // It also provides an opportunity to request access to write
    // operations, which will be performed by the private key
    // that MetaMask manages for the user.
    signer = await provider.getSigner();
    }
  }
  
</script>

<svelte:head>
  <title>AI VTuber Marketplace - Own, Trade, Interact with Virtual Influencers</title>
</svelte:head>

<div class="hero min-h-screen bg-base-200">
  <div class="hero-content flex-col lg:flex-row-reverse">
    <div class="carousel w-full max-w-sm lg:max-w-md">
      {#each featuredVTubers as vtuber, index}
        <div class="carousel-item w-full" class:hidden={index !== currentVTuber}>
          <img src={vtuber.image} alt={vtuber.name} class="rounded-lg shadow-2xl" />
          <div class="absolute bottom-0 left-0 right-0 bg-base-100 bg-opacity-75 p-4">
            <h3 class="text-xl font-bold">{vtuber.name}</h3>
            <p>{vtuber.traits.join(', ')}</p>
          </div>
        </div>
      {/each}
    </div>
    <div class="text-center lg:text-left">
      <h1 class="text-5xl font-bold">AI VTuber Marketplace</h1>
      <p class="py-6">Own, Trade, and Interact with Virtual Influencers</p>
      <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
        <a href="/marketplace" class="btn btn-primary">Browse VTubers</a>
        <a href="/create" class="btn btn-secondary">Create VTuber</a>
        <button class="btn btn-outline" on:click={() => document.getElementById('info-section').scrollIntoView({ behavior: 'smooth' })}>Learn More</button>
      </div>
    </div>
  </div>
</div>

<section id="info-section" class="py-16 bg-base-100">
  <div class="container mx-auto px-4">
    <h2 class="text-3xl font-bold text-center mb-8">How It Works</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div class="card bg-base-200 shadow-xl">
        <div class="card-body items-center text-center">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 text-primary mb-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          <h3 class="card-title">Own Your VTuber</h3>
          <p>Create and fully own your unique virtual influencer as an NFT on the blockchain.</p>
        </div>
      </div>
      <div class="card bg-base-200 shadow-xl">
        <div class="card-body items-center text-center">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 text-primary mb-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.456 2.456L21.75 6l-1.035.259a3.375 3.375 0 00-2.456 2.456zM16.894 20.567L16.5 21.75l-.394-1.183a2.25 2.25 0 00-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 001.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 001.423 1.423l1.183.394-1.183.394a2.25 2.25 0 00-1.423 1.423z" />
          </svg>
          <h3 class="card-title">AI-Powered Interactions</h3>
          <p>Engage with AI-driven VTubers that have unique personalities and interactive capabilities.</p>
        </div>
      </div>
      <div class="card bg-base-200 shadow-xl">
        <div class="card-body items-center text-center">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 text-primary mb-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 3v11.25A2.25 2.25 0 006 16.5h2.25M3.75 3h-1.5m1.5 0h16.5m0 0h1.5m-1.5 0v11.25A2.25 2.25 0 0118 16.5h-2.25m-7.5 0h7.5m-7.5 0l-1 3m8.5-3l1 3m0 0l.5 1.5m-.5-1.5h-9.5m0 0l-.5 1.5m.75-9l3-3 2.148 2.148A12.061 12.061 0 0116.5 7.605" />
          </svg>
          <h3 class="card-title">Decentralized & Scalable</h3>
          <p>Built on blockchain technology for transparency, security, and unlimited growth potential.</p>
        </div>
      </div>
    </div>
  </div>
</section>