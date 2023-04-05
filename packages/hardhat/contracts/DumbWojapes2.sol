// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface DumbWojapes {

  struct TokenOwnership {
    address addr;
    uint64 startTimestamp;
  }

  function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory);
}

contract DumbWojapes2 is Ownable, ERC721A {
  using Strings for uint256;
  using Address for address;

  DumbWojapes public immutable wojapes;
  // State variables are not finalized and will be changed
  uint256 public constant maxSupply = 777;
  uint256 public mintsWl = 2;
  uint256 public claimPerWojape = 4;
  uint256 private reserve = 30;
  uint256 public minHoldTime = 60;
  // Variables for starting/pausing mint stages
  bool public wlMintActive = false;
  bool public holderMintActive = false;
  // Keys are wojapes IDs
  mapping(uint256 => bool) public wojapesClaimed;
  mapping(address => uint256) public mintedWls;

  string public baseURI;

  bytes32 public merkleRoot;


  constructor(address _wojapesAddress, bytes32 _merkleRoot) ERC721A("Dumb Wojapes 2", "WOJAPES 2") {
    wojapes = DumbWojapes(_wojapesAddress);
    merkleRoot = _merkleRoot;
  }

  // Owners mint function, limited by the `reserve` variable
  function reserveTokens(uint256 _mintAmount) external onlyOwner {
    require(_mintAmount <= reserve, "Requested mint count exceeds reserve limit!");
    reserve -= _mintAmount;
    _safeMint(msg.sender, _mintAmount);
  }

  // Wojapes holders mint funcion, sets mapping with Wojapes IDs to false for every minted ID and calls mint wrapper
  function mintHolders(uint256[] calldata _wojapesTokenIds) external {
    require(holderMintActive, "Claiming is not live!");

    for (uint256 i; i < _wojapesTokenIds.length; ++i) {
        uint256 wojapeId = _wojapesTokenIds[i];

        DumbWojapes.TokenOwnership memory tokenOwnership = wojapes.getOwnershipData(wojapeId);
        address tokenOwner = tokenOwnership.addr;

        require(tokenOwner == msg.sender, "Can't confirm ownership!");
        require(!wojapesClaimed[wojapeId], "You already claimed your Wojapes!");

        uint256 ownershipStart = uint256(tokenOwnership.startTimestamp);
        require(block.timestamp - ownershipStart >= minHoldTime, "Minimum hold time haven't passed!");

        wojapesClaimed[wojapeId] = true;
        }

    _mintForWojapes(msg.sender, _wojapesTokenIds.length);
  }
// Function to wrap mints, every Wojape ID will mint 4 Wojapes 2
  function _mintForWojapes(address _to, uint256 _numWojapeTokens) internal {
    
    uint256 numToMint = _numWojapeTokens * claimPerWojape;
    uint256 numBatches = numToMint / 12;

    require(totalSupply() + numToMint <= maxSupply - reserve, "Max supply reached!");

    for (uint256 i; i < numBatches; ++i) {
      _mint(_to, 12);
    }
    if (numToMint % 12 > 0) {
      _mint(_to, numToMint % 12);
    }
  }

  // Second stage of minting- whitelist mint. Callers with WL minting up to 2 NFTs for .01 ether each
  function mintWhitelist(
    bytes32[] calldata _merkleProof,
    uint256 _mintAmount
  ) external payable {
    require(wlMintActive, "WL mint is not live!");
    require(totalSupply() + _mintAmount <= maxSupply - reserve);
    require(msg.sender == tx.origin, "contracts can't mint!");
    require(mintedWls[msg.sender] + _mintAmount <= mintsWl, "You already minted your WL!");
    require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Merkle verification failed!");

    mintedWls[msg.sender] += _mintAmount;
    _mint(msg.sender, _mintAmount);
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

    string memory currentBaseURI = _baseURI();
    return
      bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
  }

  // State variables setter and getters 
  function releaseReserve() external onlyOwner {
    reserve = 0;
  }

  function setWhitelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
    merkleRoot = _merkleRoot;
  }

  function setWlMintActive(bool _wlMintActive) external onlyOwner {
    wlMintActive = _wlMintActive;
  }

  function setHolderMintActive(bool _holderMintActive) external onlyOwner {
    holderMintActive = _holderMintActive;
  }

  function setBaseURI(string memory _baseURI) external onlyOwner {
    baseURI = _baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }
  // Withdraw function could be modified according to a desire
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(owner()).call{value: address(this).balance}("");
    require(success, "Transcation failed!");
  }
}

// Feed the cat
