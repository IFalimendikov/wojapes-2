require('dotenv').config()
require ("@nomicfoundation/hardhat-toolbox");
require ("hardhat-deploy");
require("@nomiclabs/hardhat-etherscan");

const providerApiKey = process.env.ALCHEMY_API_KEY_SEPOLIA;
const privateKey = process.env.DEPLOYER_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.7",
  networks: {
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${providerApiKey}`,
      accounts: [`0x${privateKey}`],
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${providerApiKey}`,
      accounts: [`0x${privateKey}`],
    },
  },
    etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY,
    },
};