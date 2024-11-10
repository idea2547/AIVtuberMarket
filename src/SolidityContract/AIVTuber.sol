// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VTuberNFT is ERC721URIStorage, Ownable {
    struct VTuber {
        string name;
        string personality;
        string voiceType;
        string[] traits;
        string description;
        uint256 price;
        uint256 royalties; // In percentage (up to 25)
        address creator;
        bool forSale;
    }

    // Mapping from token ID to VTuber details
    mapping(uint256 => VTuber) public vtubers;

    uint256 public tokenCounter;

    event VTuberMinted(
        uint256 indexed tokenId,
        string name,
        address indexed creator,
        uint256 price,
        uint256 royalties
    );

    event VTuberPurchased(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 price
    );

    constructor(address initialOwner) Ownable(initialOwner) ERC721("VTuberNFT", "VTVR") {
        tokenCounter = 0;
    }

    // Mint function to create a new VTuber NFT
    function mintVTuber(
        string memory _name,
        string memory _personality,
        string memory _voiceType,
        string[] memory _traits,
        string memory _description,
        uint256 _price,
        uint256 _royalties,
        string memory _tokenURI
    ) public returns (uint256) {
        require(_price > 0, "Price must be greater than zero");
        require(_royalties <= 25, "Royalties cannot exceed 25%");

        // Create and mint a new VTuber NFT
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        // Store VTuber details
        vtubers[newTokenId] = VTuber({
            name: _name,
            personality: _personality,
            voiceType: _voiceType,
            traits: _traits,
            description: _description,
            price: _price,
            royalties: _royalties,
            creator: msg.sender,
            forSale: true
        });

        tokenCounter += 1;

        emit VTuberMinted(newTokenId, _name, msg.sender, _price, _royalties);

        return newTokenId;
    }

    // Function to purchase a VTuber NFT
    function purchaseVTuber(uint256 tokenId) public payable {
        VTuber storage vtuber = vtubers[tokenId];

        require(vtuber.forSale, "This NFT is not for sale");
        require(msg.value >= vtuber.price, "Insufficient funds to purchase");

        address creator = vtuber.creator;
        address seller = ownerOf(tokenId);

        // Calculate royalties if the creator is not the seller (secondary sale)
        uint256 royaltyAmount = 0;
        if (seller != creator) {
            royaltyAmount = (msg.value * vtuber.royalties) / 100;
            payable(creator).transfer(royaltyAmount);
        }

        // Transfer remaining funds to the seller
        payable(seller).transfer(msg.value - royaltyAmount);

        // Transfer ownership of the NFT to the buyer
        _transfer(seller, msg.sender, tokenId);

        // Set NFT as no longer for sale
        vtuber.forSale = false;

        emit VTuberPurchased(tokenId, msg.sender, vtuber.price);
    }

    // Function to retrieve VTuber details by tokenId
    function getVTuberDetails(uint256 tokenId) public view returns (
        string memory name,
        string memory personality,
        string memory voiceType,
        string[] memory traits,
        string memory description,
        uint256 price,
        uint256 royalties,
        address creator,
        bool forSale
    ) {
        VTuber memory vtuber = vtubers[tokenId];
        return (
            vtuber.name,
            vtuber.personality,
            vtuber.voiceType,
            vtuber.traits,
            vtuber.description,
            vtuber.price,
            vtuber.royalties,
            vtuber.creator,
            vtuber.forSale
        );
    }

    // Function to set an NFT for sale
    function setForSale(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can sell the NFT");
        VTuber storage vtuber = vtubers[tokenId];
        vtuber.price = price;
        vtuber.forSale = true;
    }
}
