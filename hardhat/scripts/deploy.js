// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const DumbWojapes2 = await hre.ethers.getContractFactory("DumbWojapes2");
  const dumbWojapes2 = await DumbWojapes2.deploy("0x00B07317e8eE314F5Aca2ee3ABCD1967722a557c", "0x2f366d199e745ba954e82687a583bf26f94dd1a3d16f4504a3c8e53a2a5a506a");

  await dumbWojapes2.deployed();

  console.log("Contract deployed at:", dumbWojapes2.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
