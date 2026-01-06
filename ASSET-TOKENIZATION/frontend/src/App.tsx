import { useState, useEffect } from 'react';
import { useAccount, useConnect, useDisconnect, useReadContract, useWriteContract, useWatchContractEvent } from 'wagmi';
import { parseEther } from 'viem';
import { contracts, contractAddresses } from './config/contracts';
import './App.css';

function App() {
  const [kycAddress, setKycAddress] = useState('0x123...');
  const [userTokens, setUserTokens] = useState<bigint>(0n);

  const { address, isConnected, chain } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();
  const { writeContract } = useWriteContract();

  // Get contract addresses for current chain
  const chainId = chain?.id || 31337;
  const addresses = contractAddresses[chainId as keyof typeof contractAddresses];

  // Read user token balance
  const { data: balance, refetch: refetchBalance } = useReadContract({
    address: addresses?.myToken as `0x${string}`,
    abi: contracts.myToken.abi,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
  });

  // Update userTokens when balance changes
  useEffect(() => {
    if (balance !== undefined) {
      setUserTokens(balance as bigint);
    }
  }, [balance]);

  // Watch for Transfer events to this address
  useWatchContractEvent({
    address: addresses?.myToken as `0x${string}`,
    abi: contracts.myToken.abi,
    eventName: 'Transfer',
    args: address ? { to: address } : undefined,
    onLogs: () => {
      refetchBalance();
    },
  });

  // Handle KYC whitelisting
  const handleKycWhitelisting = async () => {
    if (!addresses) return;

    try {
      await writeContract({
        address: addresses.kycContract as `0x${string}`,
        abi: contracts.kycContract.abi,
        functionName: 'setKycCompleted',
        args: [kycAddress as `0x${string}`],
      });
      alert(`KYC for ${kycAddress} is completed`);
    } catch (error) {
      console.error('KYC whitelisting failed:', error);
      alert('KYC whitelisting failed. See console for details.');
    }
  };

  // Handle buying tokens
  const handleBuyTokens = async () => {
    if (!addresses || !address) return;

    try {
      await writeContract({
        address: addresses.myTokenSale as `0x${string}`,
        abi: contracts.myTokenSale.abi,
        functionName: 'buyTokens',
        args: [address],
        value: parseEther('0.000000000000000001'), // 1 wei
      });
    } catch (error) {
      console.error('Token purchase failed:', error);
      alert('Token purchase failed. See console for details.');
    }
  };

  if (!isConnected) {
    return (
      <div className="App">
        <h1>StarDucks Cappucino Token Sale</h1>
        <p>Please connect your wallet to continue</p>
        <div>
          {connectors.map((connector) => (
            <button
              key={connector.id}
              onClick={() => connect({ connector })}
              type="button"
            >
              Connect {connector.name}
            </button>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      <h1>StarDucks Cappucino Token Sale</h1>
      <div style={{ marginBottom: '20px' }}>
        <p>Connected: {address}</p>
        <button onClick={() => disconnect()} type="button">
          Disconnect
        </button>
      </div>

      <p>Get your Tokens today!</p>

      <h2>KYC Whitelisting</h2>
      <div>
        <label>
          Address to allow:{' '}
          <input
            type="text"
            name="kycAddress"
            value={kycAddress}
            onChange={(e) => setKycAddress(e.target.value)}
          />
        </label>
        <button type="button" onClick={handleKycWhitelisting}>
          Add to Whitelist
        </button>
      </div>

      <h2>Buy Tokens</h2>
      <p>
        If you want to buy tokens, send Wei to this address:{' '}
        {addresses?.myTokenSale}
      </p>
      <p>You currently have: {userTokens.toString()} CAPPU Tokens</p>
      <button type="button" onClick={handleBuyTokens}>
        Buy more tokens
      </button>
    </div>
  );
}

export default App;
