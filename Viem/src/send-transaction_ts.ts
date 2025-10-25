import { createWalletClient, createPublicClient, http, parseEther } from 'viem'
import { foundry } from 'viem/chains'
import { privateKeyToAccount } from 'viem/accounts'
import type { Address } from 'viem'

// Anvilから取得した秘密鍵を使用（Account #0）
const account = privateKeyToAccount('0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80')

// Wallet Clientの作成（書き込み用）
const walletClient = createWalletClient({
  account,
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
})

// Public Clientの作成（読み取り用）
const publicClient = createPublicClient({
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
})

// Account #0 から Account #1 に 1 ETH送信
const hash = await walletClient.sendTransaction({
  to: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8' as Address, // Account #1
  value: parseEther('1') // 1 ETH
})

console.log('Transaction Hash:', hash)

// トランザクションの確認を待つ
const receipt = await publicClient.waitForTransactionReceipt({ hash })
console.log('Transaction Status:', receipt.status)