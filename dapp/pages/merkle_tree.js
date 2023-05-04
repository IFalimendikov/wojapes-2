import { MerkleTree } from 'merkletreejs';
import { keccak256 } from "@ethersproject/keccak256";

let whitelistedAddresses = [
    "0x605ecF02C48bB922746fa1EA5d20c1004E759Ba1",
    "0x0ceeC204A7C4B9530F69AA448FbeFe1d0524cF0B"
];


const leafNodes = whitelistedAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

const rootHash = merkleTree.getHexRoot();


const hashedAddress = keccak256("0x605ecF02C48bB922746fa1EA5d20c1004E759Ba1");
const proof = merkleTree.getHexProof(hashedAddress);
const root = merkleTree.getHexRoot();

const valid = merkleTree.verify(proof, hashedAddress, root);


console.log(`Root is\n`, rootHash.toString("hex"));
console.log(`Merkle Tree\n`, merkleTree.toString());

console.log(`Root is\n`, proof.toString("hex"));
console.log(`Merkle Tree\n`, root.toString());

console.log(`Root is\n`, valid.toString("hex"));

