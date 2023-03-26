require("@nomicfoundation/hardhat-toolbox");

require("@nomiclabs/hardhat-ethers");
require('dotenv').config();



const { PRIVATE_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const defaultNetwork = "scroll"
module.exports = {
  networks: {
    localhost: { url: "http://127.0.0.1:8545"},
    scroll: {
      url: "https://alpha-rpc.scroll.io/l2",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 2000000000,
      gasMultiplier: 1.5,
      chainId: 534353,
    },
  },
  solidity: {
    compilers: [
      {
        version: '0.8.9',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 20000,
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  etherscan: {
    apiKey: '',
  },
};
