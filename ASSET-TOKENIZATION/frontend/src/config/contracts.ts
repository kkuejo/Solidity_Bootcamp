import MyTokenABI from '../contracts/MyToken.json';
import MyTokenSaleABI from '../contracts/MyTokenSale.json';
import KycContractABI from '../contracts/KycContract.json';

// Contract addresses - update these with your deployed contract addresses
export const contractAddresses = {
  // Anvil local testnet (chainId: 31337)
  31337: {
    myToken: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    myTokenSale: '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
    kycContract: '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0',
  },
  // Add other networks as needed
} as const;

export const contracts = {
  myToken: {
    abi: MyTokenABI,
  },
  myTokenSale: {
    abi: MyTokenSaleABI,
  },
  kycContract: {
    abi: KycContractABI,
  },
} as const;
