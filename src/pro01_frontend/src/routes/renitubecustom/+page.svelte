<script lang="ts">
    import { appStore, speakStore } from "../../stores/modelStore";
    import { onMount } from "svelte";
    import '@pixi/unsafe-eval';

    import ReniTubeShow from "./ReniTubeShow.svelte";

    import { ethers } from 'ethers';

    let provider;
    let signer;
    let userAddress = '';
    let isConnected = false;
    let loyaltyPoints = 0;
    let availableRewards = [
        { name: "10% Discount", cost: 100 },
        { name: "Free Shipping", cost: 200 },
        { name: "Exclusive Item", cost: 500 }
    ];

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


  // Contract ABI and address
  const contractABI = [
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
            "inputs": [],
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
            "inputs": [],
            "name": "mintNFT",
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
        }
    ];
  const contractAddress = '0x7e90685798bC90Dca7f44bc2aEf450711be5dD69';

  let contract;

  // Connect to Ethereum
  async function connect() {
    // Check if MetaMask or another provider is installed
    if (window.ethereum) {
      try {
        // Request access to the user's Ethereum account
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        provider = new ethers.BrowserProvider(window.ethereum);
        signer = provider.getSigner();

        // Initialize the contract
        contract = new ethers.Contract(contractAddress, contractABI, signer);

        console.log('Connected to Ethereum and initialized contract');
      } catch (error) {
        console.error('User denied account access or other error:', error);
      }
    } else {
      console.error('Please install MetaMask or another Ethereum provider');
    }
  }

  // Example function to call a Solidity function
  async function callMyFunction() {
    if (!contract) {
      console.error('Contract not initialized');
      return;
    }

    try {
      // Call a read-only function on the contract
      const result = await contract.symbol(); // Replace `myFunction` with your Solidity function name
      console.log('Function result:', result);
    } catch (error) {
      console.error('Error calling contract function:', error);
    }
  }

    let isLoading = false;
    let pixiApp;
    let speak;

    // Text area value
    let text = "";

    let mediaRecorder;
    let audioElement;
    let recordedChunks = [];

    onMount(() => {
        const unsubscribe = speakStore.subscribe(value => {
            speak = value;
            console.log("Speak loaded.", speak);
        });

        const unsubscribeApp = appStore.subscribe(value => {
            pixiApp = value;
            console.log("Model loaded.", pixiApp);
        });

        return () => {
            unsubscribe();
            unsubscribeApp();
        }
    });

    // onMount(async () => {
    //     const canvas = document.getElementById('canvas') as HTMLCanvasElement;
    //     const canvasStream = canvas.captureStream(30); // 30 FPS

    //     // Create an audio context
    //     const audioContext = new AudioContext();
    //     const destination = audioContext.createMediaStreamDestination();

    //     // Capture audio from the browser (e.g., the speak function)
    //     audioElement = new Audio('https://awsrvc01.celestiai.co/file=/tmp/gradio/645415139418315ecd564f50bb2294150b7b3bb4/tts_rvc_output.wav');
    //     audioElement.crossOrigin = 'anonymous';
    //     const audioSource = audioContext.createMediaElementSource(audioElement);
    //     audioSource.connect(destination);
    //     audioSource.connect(audioContext.destination);

    //     const newStream = new MediaStream();
    //     // Combine the canvas stream and the audio stream
    //     const audioTracks = destination.stream.getAudioTracks();
    //     const canvasTracks = canvasStream.getVideoTracks();
    //     if (audioTracks.length > 0) {
    //         newStream.addTrack(audioTracks[0]);
    //         newStream.addTrack(canvasTracks[0]);
    //         console.log("Combined audio and video tracks.");
    //     } else {
    //         console.error("No audio tracks found");
    //     }

    //     // video/webm; codecs=vp9
    //     mediaRecorder = new MediaRecorder(newStream, { mimeType: 'video/webm; codecs=vp9' });
    //     console.log(mediaRecorder);

    //     mediaRecorder.ondataavailable = (event) => {
    //         console.log(event);
    //         if (event.data.size > 0) {
    //             recordedChunks.push(event.data);
    //         } else {
    //             console.log("No data available.");
    //         }
    //     };

    //     mediaRecorder.onstop = () => {
    //         const blob = new Blob(recordedChunks, { type: 'video/webm' });
    //         const formData = new FormData();
    //         formData.append('fileBlob', blob);

    //         fetch('/api/upload_Files', {
    //             method: 'POST',
    //             body: formData
    //         }).then(response => {
    //             console.log("Finished Render and uploaded.");
    //         });
    //     };
    // });

    const startRecording = () => {
        console.log(mediaRecorder);
        recordedChunks = [];
        mediaRecorder.start();
        setTimeout(stopRecording, 10000);
    };

    const stopRecording = () => {
        mediaRecorder.stop();
    };

    const handleGenerateSound = async () => {
        if (text === "") {
            alert("Please input some text.");
            return;
        }

        isLoading = true;
        const response = await fetch('api/gen_sound_new', {
                body: JSON.stringify({ selected: 'logs/Sumi/Sumi.pth', text: text, transpose: 0, speaker: 'en-US-AnaNeural', speed: 0 }),
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
        }).then(async res => {
            if (!res.ok) {
                throw new Error("Network response was not ok");
            }

            const responseSound = await res.json();
            isLoading = false;

            // Set up the audio element with the new sound
            audioElement = new Audio(responseSound);
            audioElement.crossOrigin = 'anonymous';

            // Set up the audio context and media recorder
            const canvas = document.getElementById('canvas') as HTMLCanvasElement;
            const canvasStream = canvas.captureStream(30); // 30 FPS

            const audioContext = new AudioContext();
            const destination = audioContext.createMediaStreamDestination();

            const audioSource = audioContext.createMediaElementSource(audioElement);
            audioSource.connect(destination);
            audioSource.connect(audioContext.destination);

            const newStream = new MediaStream();
            const audioTracks = destination.stream.getAudioTracks();
            const canvasTracks = canvasStream.getVideoTracks();
            if (audioTracks.length > 0) {
                newStream.addTrack(audioTracks[0]);
                newStream.addTrack(canvasTracks[0]);
                console.log("Combined audio and video tracks.");
            } else {
                console.error("No audio tracks found");
            }

            mediaRecorder = new MediaRecorder(newStream, { mimeType: 'video/webm; codecs=vp9' });
            console.log(mediaRecorder);

            mediaRecorder.ondataavailable = (event) => {
                console.log(event);
                if (event.data.size > 0) {
                    recordedChunks.push(event.data);
                } else {
                    console.log("No data available.");
                }
            };

            mediaRecorder.onstop = () => {
                const blob = new Blob(recordedChunks, { type: 'video/webm' });
                const formData = new FormData();
                formData.append('fileBlob', blob);

                fetch('/api/upload_Files', {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    console.log("Finished Render and uploaded.");
                });
            };

            // Start recording and play the audio
            startRecording();
            audioElement.play();
            speak(responseSound);
        });
        // .then(() => {
        //     const checkVideoEnd = () => {
        //         const video = document.querySelector('video');
        //         if (video && video.currentTime >= video.duration) {
        //             stopRecording();
        //         } else {
        //             requestAnimationFrame(checkVideoEnd);
        //         }
        //     };
        //     checkVideoEnd();
        // });
    }

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
    async function fetchLoyaltyPoints() {
        if (contract && userAddress) {
            try {
                loyaltyPoints = await contract.getPoints(userAddress);
            } catch (error) {
                console.error('Error fetching loyalty points:', error);
            }
        }
    }

    async function earnPoints() {
        if (contract) {
            try {
                const tx = await contract.earnPoints(10); // Earn 10 points for this action
                await tx.wait();
                await fetchLoyaltyPoints();
            } catch (error) {
                console.error('Error earning points:', error);
            }
        }
    }

    async function redeemReward(rewardId) {
        if (contract) {
            try {
                const tx = await contract.redeemReward(rewardId);
                await tx.wait();
                await fetchLoyaltyPoints();
            } catch (error) {
                console.error('Error redeeming reward:', error);
            }
        }
    }

    let fileInput;

    function handleFileUpload() {
        const file = fileInput.files[0];
        if (file) {
            // Here you would implement the logic to upload the file to DFINITY ICP
            console.log('Uploading file:', file.name);
            // Placeholder for actual upload logic
            alert(`File ${file.name} selected for upload to DFINITY ICP`);
        }
    }
</script>

<div class="min-h-screen bg-base-200 flex flex-col items-center justify-center p-4">
    <div class="card bg-base-100 shadow-xl w-full max-w-2xl">
        <div class="card-body">
            <h2 class="card-title justify-center">Loyalty Program</h2>
            
            {#if isConnected}
                <p class="text-center">Connected as: {userAddress}</p>
                <p class="text-center font-bold">Loyalty Points: {loyaltyPoints}</p>
                <div class="flex justify-center mt-4">
                    <button class="btn btn-primary" on:click={earnPoints}>Earn Points</button>
                </div>
                <div class="divider">Available Rewards</div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    {#each availableRewards as reward, index}
                        <div class="card bg-base-200 shadow-sm">
                            <div class="card-body p-4">
                                <h3 class="card-title text-sm justify-center">{reward.name}</h3>
                                <p class="text-center">{reward.cost} points</p>
                                <div class="card-actions justify-center mt-2">
                                    <button class="btn btn-sm btn-outline" 
                                            on:click={() => redeemReward(index)}
                                            disabled={loyaltyPoints < reward.cost}>
                                        Redeem
                                    </button>
                                </div>
                            </div>
                        </div>
                    {/each}
                </div>
            {:else}
                <div class="flex justify-center">
                    <button class="btn btn-primary" on:click={connectWallet}>Connect Wallet</button>
                </div>
            {/if}

            <div class="divider">VTube Preview</div>
            <div id="videoLayer" class="border-t border-t-base-300 border-b border-b-base-300 bg-[url('/resource/hiyori_pro_en/grid.png')]">
                <ReniTubeShow />
                <div class="mb-4 w-1/2 mx-auto flex items-center justify-start bg-base-200 rounded-2xl px-2">
                    <button type="button" class="btn btn-ghost btn-circle">▶</button>
                </div>
            </div>

            <div class="form-control w-full max-w-xs mx-auto mt-4">
                <label for="live2d-upload" class="label">
                    <span class="label-text">Upload Live2D Model</span>
                </label>
                <input type="file" id="live2d-upload" class="file-input file-input-bordered w-full max-w-xs" bind:this={fileInput} on:change={handleFileUpload} accept=".model3.json"/>
            </div>
        </div>
    </div>
</div>

