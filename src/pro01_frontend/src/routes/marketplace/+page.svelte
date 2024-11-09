<script>
    import { onMount } from 'svelte';
  
    let vtubers = [
      { id: 1, name: 'Aiko', image: '/placeholder.svg?height=300&width=300', traits: ['Cheerful', 'Energetic'], voice: 'Soprano', price: 0.5 },
      { id: 2, name: 'Neo', image: '/placeholder.svg?height=300&width=300', traits: ['Cool', 'Mysterious'], voice: 'Baritone', price: 0.7 },
      { id: 3, name: 'Luna', image: '/placeholder.svg?height=300&width=300', traits: ['Elegant', 'Calm'], voice: 'Alto', price: 0.6 },
      { id: 4, name: 'Zephyr', image: '/placeholder.svg?height=300&width=300', traits: ['Adventurous', 'Witty'], voice: 'Tenor', price: 0.8 },
      { id: 5, name: 'Sakura', image: '/placeholder.svg?height=300&width=300', traits: ['Shy', 'Kind'], voice: 'Mezzo-soprano', price: 0.55 },
      { id: 6, name: 'Atlas', image: '/placeholder.svg?height=300&width=300', traits: ['Strong', 'Dependable'], voice: 'Bass', price: 0.75 },
    ];
  
    let sortOption = 'price';
    let filterTrait = '';
    let selectedVTuber = null;
  
    $: sortedVTubers = [...vtubers].sort((a, b) => {
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
  
    onMount(() => {
      // In a real application, you would fetch VTubers data from an API here
    });
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
      {#each filteredVTubers as vtuber (vtuber.id)}
        <div class="card bg-base-100 shadow-xl">
          <figure><img src={vtuber.image} alt={vtuber.name} class="w-full h-48 object-cover" /></figure>
          <div class="card-body">
            <h2 class="card-title">{vtuber.name}</h2>
            <p>Traits: {vtuber.traits.join(', ')}</p>
            <p>Voice: {vtuber.voice}</p>
            <p class="text-xl font-bold">{vtuber.price} ETH</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary" on:click={() => openModal(vtuber)}>View Details</button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  </div>
  
  {#if selectedVTuber}
    <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="modal-box w-11/12 max-w-2xl">
        <h3 class="font-bold text-lg mb-4">{selectedVTuber.name}</h3>
        <img src={selectedVTuber.image} alt={selectedVTuber.name} class="w-full h-64 object-cover rounded-lg mb-4" />
        <p class="mb-2"><strong>Traits:</strong> {selectedVTuber.traits.join(', ')}</p>
        <p class="mb-2"><strong>Voice:</strong> {selectedVTuber.voice}</p>
        <p class="mb-4"><strong>Price:</strong> {selectedVTuber.price} ETH</p>
        <div class="mb-4">
          <h4 class="font-bold mb-2">Interaction Preview:</h4>
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