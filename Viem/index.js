// index.js
import { createPublicClient, createWalletClient, http, parseEther } from 'viem';
import { foundry } from 'viem/chains';
import { privateKeyToAccount } from 'viem/accounts';

// Public Client（読み取り用）
const publicClient = createPublicClient({
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
});

// AnvilのAccount #0の秘密鍵
const account = privateKeyToAccount('0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80');

// Wallet Client（書き込み用）
const walletClient = createWalletClient({
  account,
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
});

async function main() {
  console.log('=== Viem + Anvil Tutorial ===\n');

  // Account #0 と #1 のアドレス
  const account0 = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
  const account1 = '0x70997970C51812dc3A010C7d01b50e0d17dc79C8';

  // 初期残高を確認
  console.log('初期残高:');
  const balance0Before = await publicClient.getBalance({ address: account0 });
  const balance1Before = await publicClient.getBalance({ address: account1 });
  
  console.log(`Account #0: ${balance0Before / BigInt(10**18)} ETH`);
  console.log(`Account #1: ${balance1Before / BigInt(10**18)} ETH\n`);

  // 1 ETHを送信
  console.log('1 ETH を Account #0 から Account #1 に送信中...');
  const hash = await walletClient.sendTransaction({
    to: account1,
    value: parseEther('1')
  });
  
  console.log('Transaction Hash:', hash);

  // トランザクションの確認
  const receipt = await publicClient.waitForTransactionReceipt({ hash });
  console.log('Transaction Status:', receipt.status, '\n');

  // 送信後の残高を確認
  console.log('送信後の残高:');
  const balance0After = await publicClient.getBalance({ address: account0 });
  const balance1After = await publicClient.getBalance({ address: account1 });
  
  console.log(`Account #0: ${balance0After / BigInt(10**18)} ETH`);
  console.log(`Account #1: ${balance1After / BigInt(10**18)} ETH`);
}

main().catch(console.error);