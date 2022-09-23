require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "goerli",
  networks:{
    goerli:{
      url: process.env.ALCHEMY_KEY,
      accounts:[process.env.KEY_1,process.env.KEY_2,process.env.KEY_3]
    }
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: false,
        runs: 200
      }
    }
  },
};
