<script>
    import { onMount } from 'svelte';
    import { ethers } from 'ethers';
  
    let account = '';
    let ownedVTubers = [];
    let sortOption = 'price';
    let filterTrait = '';
    let selectedVTuber = null;
    let loading = true;
    let error = null;

  
    const CONTRACT_ADDRESS = '0xa02C12b43E27102e0022968Bdf48c3F87c7B5A25'; // Replace with actual address
    const CONTRACT_ABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "initialOwner",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "ERC721IncorrectOwner",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "ERC721InsufficientApproval",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "approver",
				"type": "address"
			}
		],
		"name": "ERC721InvalidApprover",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			}
		],
		"name": "ERC721InvalidOperator",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "ERC721InvalidOwner",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "receiver",
				"type": "address"
			}
		],
		"name": "ERC721InvalidReceiver",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sender",
				"type": "address"
			}
		],
		"name": "ERC721InvalidSender",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "ERC721NonexistentToken",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "OwnableInvalidOwner",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "OwnableUnauthorizedAccount",
		"type": "error"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "approved",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "operator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "approved",
				"type": "bool"
			}
		],
		"name": "ApprovalForAll",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_fromTokenId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_toTokenId",
				"type": "uint256"
			}
		],
		"name": "BatchMetadataUpdate",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "MetadataUpdate",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_personality",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_voiceType",
				"type": "string"
			},
			{
				"internalType": "string[]",
				"name": "_traits",
				"type": "string[]"
			},
			{
				"internalType": "string",
				"name": "_description",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_price",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_royalties",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_tokenURI",
				"type": "string"
			}
		],
		"name": "mintVTuber",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "purchaseVTuber",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "safeTransferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			}
		],
		"name": "safeTransferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "approved",
				"type": "bool"
			}
		],
		"name": "setApprovalForAll",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			}
		],
		"name": "setForSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "creator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "royalties",
				"type": "uint256"
			}
		],
		"name": "VTuberMinted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "buyer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			}
		],
		"name": "VTuberPurchased",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "getApproved",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "getVTuberDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "personality",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "voiceType",
				"type": "string"
			},
			{
				"internalType": "string[]",
				"name": "traits",
				"type": "string[]"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "royalties",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "creator",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "forSale",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			}
		],
		"name": "isApprovedForAll",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "ownerOf",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes4",
				"name": "interfaceId",
				"type": "bytes4"
			}
		],
		"name": "supportsInterface",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tokenCounter",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "tokenURI",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "vtubers",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "personality",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "voiceType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "royalties",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "creator",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "forSale",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
  
async function connectWallet() {
    if (typeof window.ethereum !== 'undefined') {
      try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        account = await signer.getAddress();
        await fetchOwnedVTubers();
      } catch (e) {
        console.error("Error connecting wallet:", e);
        error = "Failed to connect wallet. Please try again.";
        loading = false;
      }
    } else {
      error = "Please install MetaMask or another Ethereum wallet to use this feature.";
      loading = false;
    }
  }

  async function fetchOwnedVTubers() {
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, provider);

      const balance = await contract.balanceOf(account);
      
      let fetchedVTubers = [];
      for (let i = 0; i < balance; i++) {
        const tokenId = await contract.tokenOfOwnerByIndex(account, i);
        const vtuberDetails = await contract.getVTuberDetails(tokenId);

        const [
          name,
          personality,
          voiceType,
          traits,
          description,
          priceInWei,
          royalties,
          creator
        ] = vtuberDetails;

        const priceInEther = ethers.formatEther(priceInWei);

        fetchedVTubers.push({
          id: tokenId.toString(),
          name,
          personality,
          voiceType,
          traits,
          description,
          price: parseFloat(priceInEther),
          royalties: royalties.toString(),
          creator,
          image: `path/to/image_${tokenId}.jpg` // Replace with actual image fetching logic
        });
      }

      ownedVTubers = fetchedVTubers;
      console.log('Fetched owned VTubers:', ownedVTubers);
      loading = false;
    } catch (e) {
      console.error("Error fetching owned VTubers:", e);
      error = "Failed to load owned VTubers. Please try again later.";
      loading = false;
    }
  }

  $: sortedVTubers = [...ownedVTubers].sort((a, b) => {
    if (sortOption === 'price') return a.price - b.price;
    if (sortOption === 'name') return a.name.localeCompare(b.name);
    return 0;
  });

  $: filteredVTubers = filterTrait
    ? sortedVTubers.filter(vtuber => vtuber.traits.includes(filterTrait))
    : sortedVTubers;

  function openModal(vtuber) {
    selectedVTuber = vtuber;
  }

  function closeModal() {
    selectedVTuber = null;
  }

  function updateVTuberSettings(vtuberId) {
    // Placeholder function - implement actual update logic
    console.log(`Updating settings for VTuber ${vtuberId}`);
  }

  onMount(() => {
    connectWallet();
  });
</script>

<svelte:head>
  <title>User Profile - AI VTuber Marketplace</title>
</svelte:head>

<div class="container mx-auto px-4 py-8">
  <h1 class="text-4xl font-bold mb-8">User Profile</h1>

  {#if loading}
    <div class="text-center">
      <span class="loading loading-spinner loading-lg"></span>
      <p>Loading profile data...</p>
    </div>
  {:else if error}
    <div class="alert alert-error">
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      <span>{error}</span>
    </div>
  {:else}
    <div class="mb-8">
      <h2 class="text-2xl font-semibold mb-4">Your Wallet</h2>
      <p>Connected Address: {account}</p>
    </div>

    <div class="mb-8">
      <h2 class="text-2xl font-semibold mb-4">Your VTubers</h2>
      
      <div class="flex flex-col md:flex-row justify-between mb-6">
        <div class="form-control w-full md:w-auto mb-4 md:mb-0">
          <label for="sort" class="label">
            <span class="label-text">Sort by:</span>
          </label>
          <select bind:value={sortOption} id="sort" class="select select-bordered w-full md:w-auto">
            <option value="price">Price (Low to High)</option>
            <option value="name">Name (A to Z)</option>
          </select>
        </div>

        <div class="form-control w-full md:w-auto">
          <label for="filter" class="label">
            <span class="label-text">Filter by trait:</span>
          </label>
          <select bind:value={filterTrait} id="filter" class="select select-bordered w-full md:w-auto">
            <option value="">All Traits</option>
            {#each [...new Set(ownedVTubers.flatMap(v => v.traits))] as trait}
              <option value={trait}>{trait}</option>
            {/each}
          </select>
        </div>
      </div>

      {#if filteredVTubers.length === 0}
        <p>You don't own any VTubers yet.</p>
      {:else}
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {#each filteredVTubers as vtuber (vtuber.id)}
            <div class="card bg-base-100 shadow-xl">
              <figure><img src={vtuber.image} alt={vtuber.name} class="w-full h-48 object-cover" /></figure>
              <div class="card-body">
                <h3 class="card-title">{vtuber.name}</h3>
                <p>Traits: {vtuber.traits.join(', ')}</p>
                <p>Voice: {vtuber.voiceType}</p>
                <p class="text-xl font-bold">{vtuber.price} BFT</p>
                <div class="card-actions justify-end">
                  <button class="btn btn-primary" on:click={() => openModal(vtuber)}>View Details</button>
                  <button class="btn btn-secondary" on:click={() => updateVTuberSettings(vtuber.id)}>Update Settings</button>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/if}
    </div>
  {/if}
</div>

{#if selectedVTuber}
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
    <div class="modal-box w-11/12 max-w-2xl">
      <h3 class="font-bold text-lg mb-4">{selectedVTuber.name}</h3>
      <img src={selectedVTuber.image} alt={selectedVTuber.name} class="w-full h-64 object-cover rounded-lg mb-4" />
      <p class="mb-2"><strong>Personality:</strong> {selectedVTuber.personality}</p>
      <p class="mb-2"><strong>Traits:</strong> {selectedVTuber.traits.join(', ')}</p>
      <p class="mb-2"><strong>Voice:</strong> {selectedVTuber.voiceType}</p>
      <p class="mb-2"><strong>Description:</strong> {selectedVTuber.description}</p>
      <p class="mb-2"><strong>Price:</strong> {selectedVTuber.price} BFT</p>
      <p class="mb-4"><strong>Royalties:</strong> {selectedVTuber.royalties}%</p>
      <div class="mb-4">
        <h4 class="font-bold mb-2">Interaction Preview:</h4>
        <p class="bg-base-200 p-4 rounded-lg">
          "Hello! I'm {selectedVTuber.name}. It's great to meet you! How can I brighten your day?"
        </p>
      </div>
      <div class="modal-action">
        <button class="btn btn-primary" on:click={() => updateVTuberSettings(selectedVTuber.id)}>Update Settings</button>
        <button class="btn" on:click={closeModal}>Close</button>
      </div>
    </div>
  </div>
{/if}