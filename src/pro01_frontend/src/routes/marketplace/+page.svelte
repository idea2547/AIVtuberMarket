<script lang="ts">
  import { onMount } from 'svelte';
  import { ethers } from 'ethers';

  export const prerender = true;
	import '@pixi/unsafe-eval';

	import { Application, Ticker } from "pixi.js"
	import { appStore, speakStore } from "../../stores/modelStore";

	console.log("Top level script loaded.");

  let vtubers = [];
  let sortOption = 'price';
  let filterTrait = '';
  let selectedVTuber = null;
  

  // Replace with your actual contract details
  const CONTRACT_ADDRESS = '0x061515f8Bf0205d8e6EBBE40Bf2b3054c97d899E';
  const CONTRACT_ABI = [
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
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

  // Sort VTubers based on selected option
  $: sortedVTubers = [...vtubers].sort((a, b) => {
    if (sortOption === 'price') return a.price - b.price;
    if (sortOption === 'name') return a.name.localeCompare(b.name);
    return 0;
  });

  // Filter VTubers based on selected trait
  $: filteredVTubers = filterTrait
    ? sortedVTubers.filter(vtuber => vtuber.traits.includes(filterTrait))
    : sortedVTubers;

  // Function to fetch VTuber details from the smart contract
  async function fetchVTubers() {
    try {
      // Initialize the provider and contract
      const provider = new ethers.BrowserProvider(window.ethereum);
      const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, provider);

      // Fetch the total number of VTubers
      const vtuberCount = await contract.tokenCounter(); // Assuming there's a method to get total VTubers

      let fetchedVTubers = []; // Create a new array to store fetched VTubers

      // Loop through and fetch details for each VTuber
      for (let i = 0; i < vtuberCount; i++) {
        const vtuberDetails = await contract.getVTuberDetails(i);

		const tokenURI = await contract.tokenURI(i);

        // Extracting the details
        const [
          name,
          personality,
          voiceType,
          traits, // Assuming traits are already an array
          description,
          priceInWei,
          royalties,
          creator
        ] = vtuberDetails;

        // Convert price from Wei to Ether
        const priceInEther = ethers.formatEther(priceInWei);

        // Push the formatted VTuber to the array
        fetchedVTubers.push({
          id: i,
          name,
          personality,
          voiceType,
          traits, // No need to split if it's already an array
          description,
          price: parseFloat(priceInEther), // Convert to float for display
          royalties,
          creator,
          image: `path/to/image_${i}.jpg`, // Add placeholder image URL
		  tokenURI
        });
      }

      // Update the vtubers state after fetching data
      vtubers = fetchedVTubers;
      console.log('Fetched VTubers:', vtubers);
    } catch (error) {
      console.error('Error fetching VTubers:', error);
    }
  }

  // Open modal for viewing VTuber details
  function openModal(vtuber) {
    selectedVTuber = vtuber;
  }

  // Close modal
  function closeModal() {
    selectedVTuber = null;
  }

  // Fetch VTubers when component mounts
  onMount(() => {
    fetchVTubers();
  });
  
  
  $: if (selectedVTuber) {
    loadLive2DModel(selectedVTuber.tokenURI);
}

// Function to load the Live2D model
async function loadLive2DModel(tokenURI) {
    try {
        const { Live2DModel } = await import('pixi-live2d-display-lipsyncpatch');
        const app = new Application({
            view: document.getElementById('canvas'),
            backgroundAlpha: 0,
            resizeTo: document.getElementById('canvas')
        });

        const model = await Live2DModel.from(tokenURI, { ticker: Ticker.shared });
        app.stage.addChild(model);

        // Position and scale model
        model.x = app.screen.width / 2;
        model.y = app.screen.height / 2 + 400;
        model.scale.set(0.3, 0.3);
        model.anchor.set(0.5, 0.5);

        // Make `speak` available globally to the component
        const speak = (audioLink) => model.speak(audioLink, { crossOrigin: 'anonymous' });
        speakStore.set(speak);
        appStore.set(app);

        model.on('hit', (hitAreas) => {
            if (hitAreas.includes('Body')) {
                model.speak('/src/routes/renitube/resource/Hana/sounds/haru_talk_13.wav', {
                    crossOrigin: 'anonymous'
                });
            }
        });
    } catch (error) {
        console.error('Error loading Live2D model:', error);
    }
}
</script>

<svelte:head>
  <title>Browse VTubers - AI VTuber Marketplace</title>
</svelte:head>

<div class="container mx-auto px-4 py-8">
  <h1 class="text-4xl font-bold mb-8">Browse VTubers</h1>

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
        <option value="Cheerful">Cheerful</option>
        <option value="Cool">Cool</option>
        <option value="Elegant">Elegant</option>
        <option value="Adventurous">Adventurous</option>
        <option value="Shy">Shy</option>
        <option value="Strong">Strong</option>
      </select>
    </div>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
    {#if filteredVTubers.length === 0}
      <p>No VTubers found.</p>
    {:else}
      {#each filteredVTubers as vtuber (vtuber.id)}
        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">{vtuber.name}</h2>
            <p class="text-xl font-bold">{vtuber.price} BFT</p>
            <button on:click={() => openModal(vtuber)} class="btn btn-primary">View Details</button>
          </div>
        </div>
      {/each}
    {/if}
  </div>
</div>

{#if selectedVTuber}
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
    <div class="modal-box w-11/12 max-w-2xl">
      <h3 class="font-bold text-lg mb-4">{selectedVTuber.name}</h3>
      <img src={selectedVTuber.image} alt={selectedVTuber.name} class="w-full h-64 object-cover rounded-lg mb-4" />
      <p class="mb-2"><strong>Traits:</strong> {selectedVTuber.traits.join(', ')}</p>
      <p class="mb-2"><strong>Voice:</strong> {selectedVTuber.voiceType}</p>
      <p class="mb-4"><strong>Price:</strong> {selectedVTuber.price} BFT</p>
	  <p class="mb-4"><strong>tokenURI:</strong> {selectedVTuber.tokenURI}</p>
      <div class="mb-4">
        <h4 class="font-bold mb-2">Interaction Preview:</h4>
		<canvas id="canvas" class="w-full h-full"></canvas>
        <p class="bg-base-200 p-4 rounded-lg">
          "Hello! I'm {selectedVTuber.name}. It's great to meet you! How can I brighten your day?"
        </p>
      </div>
      <div class="modal-action">
        <button class="btn btn-primary">Buy Now</button>
        <button class="btn" on:click={closeModal}>Close</button>
      </div>
    </div>
  </div>
{/if}