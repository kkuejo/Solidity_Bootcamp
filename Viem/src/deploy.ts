// src/deploy.ts
import { 
    createPublicClient, 
    createWalletClient, 
    http 
  } from 'viem'
  import { foundry } from 'viem/chains'
  import { privateKeyToAccount } from 'viem/accounts'
  import contractJson from '../foundry/out/SomeContract.sol/SomeContract.json'
  
  const publicClient = createPublicClient({
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  const account = privateKeyToAccount(
    '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
  )
  
  const walletClient = createWalletClient({
    account,
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  async function deploy() {
    console.log('=== Deploy Starting ===')
    console.log('Deploying SomeContract...')
    
    // コントラクトをデプロイ
    const hash = await walletClient.deployContract({
      abi: contractJson.abi,
      bytecode: contractJson.bytecode.object as `0x${string}`,
      account
    })
  
    console.log('Transaction hash:', hash)
  
    // デプロイ完了を待つ
    const receipt = await publicClient.waitForTransactionReceipt({ hash })
    
    console.log('Contract deployed at:', receipt.contractAddress)
    console.log('Block number:', receipt.blockNumber.toString())
  
    return receipt.contractAddress
  }
  
console.log('スクリプト開始...')
deploy().catch(error => {
  console.error('実行エラー:', error)
})