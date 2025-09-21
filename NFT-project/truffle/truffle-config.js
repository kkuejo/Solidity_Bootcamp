/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation, and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * https://trufflesuite.com/docs/truffle/reference/configuration
 *
 * Deployment with Truffle Dashboard (Recommended for best security practice)
 * --------------------------------------------------------------------------
 *
 * Are you concerned about security and minimizing rekt status 🤔?
 * Use this method for best security:
 *
 * Truffle Dashboard lets you review transactions in detail, and leverages
 * MetaMask for signing, so there's no need to copy-paste your mnemonic.
 * More details can be found at 🔎:
 *
 * https://trufflesuite.com/docs/truffle/getting-started/using-the-truffle-dashboard/
 */

require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

// Load environment variables
const mnemonic = process.env.MNEMONIC;
const infuraProjectId = process.env.INFURA_PROJECT_ID;
const etherscanApiKey = process.env.ETHERSCAN_API_KEY;

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a managed Ganache instance for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache, geth, or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    ganache: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },

    // Truffle Dashboard - RECOMMENDED METHOD
    // This uses MetaMask for signing transactions, no mnemonic needed in config
    dashboard: {
      host: "localhost",
      port: 24012,
      network_id: "*"      // Match any network id
    },

    // Sepolia with Infura
    sepolia: {
      provider: function() {
        return new HDWalletProvider({
          mnemonic: {
            phrase: mnemonic
          },
          providerOrUrl: `https://sepolia.infura.io/v3/${infuraProjectId}`,
          numberOfAddresses: 1,
          shareNonce: true,
          derivationPath: "m/44'/60'/0'/0/",
          chainId: 11155111,
          pollingInterval: 15000,  // 15 seconds - balanced interval
          timeout: 120000,         // 120 seconds timeout
          keepAlive: false,
          websockets: false
        });
      },
      network_id: 11155111,      // Sepolia's network id
      gas: 5000000,              // Gas limit
      gasPrice: 20000000000,     // 20 gwei
      confirmations: 2,          // # of confirmations to wait between deployments
      timeoutBlocks: 200,        // # of blocks before a deployment times out
      skipDryRun: true,          // Skip dry run before migrations
      networkCheckTimeout: 999999,
      deploymentPollingInterval: 15000
    }
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.24",      // Use stable version compatible with OpenZeppelin 5.4.0
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "shanghai"  // Use shanghai for better compatibility
      }
    }
  },

  // Truffle plugin for contract verification
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: etherscanApiKey
  }

  

  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  //
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  //
  // After you backed up your artifacts you can utilize db by running migrate as follows:
  // $ truffle migrate --reset --compile-all
  //
  // db: {
  //   enabled: false,
  //   host: "127.0.0.1",
  //   adapter: {
  //     name: "indexeddb",
  //     settings: {
  //       directory: ".db"
  //     }
  //   }
  // }
};