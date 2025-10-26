// src/contract-interaction.ts
import {
    createPublicClient,
    createWalletClient,
    http,
    parseAbi,
    getContract
  } from 'viem'
  import { foundry } from 'viem/chains'
  import { privateKeyToAccount } from 'viem/accounts'
  import type { Address } from 'viem'

  // コントラクトのABI
  const contractABI = parseAbi([
    'function myUint() public view returns (uint256)',
    'function setUint(uint256 _myUint) public'
  ])

  // コントラクトアドレス（デプロイ後に表示されたアドレスに置き換えてください）
  const contractAddress: Address = '0x5fbdb2315678afecb367f032d93f642f64180aa3'

  // Public Client（読み取り用）
  const publicClient = createPublicClient({
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })

  // AnvilのAccount #0の秘密鍵
  const account = privateKeyToAccount(
    '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
  )

  // Wallet Client（書き込み用）
  const walletClient = createWalletClient({
    account,
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })

  async function main() {
    console.log('=== Viem + Foundry + Anvil Tutorial ===\n')

    // 1. コントラクトから値を読み取る（低レベル）
    console.log('--- 低レベルAPI: eth_call ---')
    const data = await publicClient.call({
      to: contractAddress,
      data: '0x06540f7e' // myUint()のfunction selector
    })
    console.log('Raw data:', data.data)
    console.log('Decoded value:', parseInt(data.data!, 16), '\n')

    // 2. readContractで読み取る（推奨）
    console.log('--- readContract API ---')
    const currentValue = await publicClient.readContract({
      address: contractAddress,
      abi: contractABI,
      functionName: 'myUint'
    })
    console.log('Current myUint value:', currentValue.toString(), '\n')

    // 3. コントラクトインスタンスを作成（さらに便利）
    console.log('--- getContract API ---')
    const contract = getContract({
      address: contractAddress,
      abi: contractABI,
      client: { public: publicClient, wallet: walletClient }
    })

    const value = await contract.read.myUint()
    console.log('myUint value:', value.toString(), '\n')

    // 4. 値を更新する
    console.log('--- Updating myUint to 50 ---')
    const hash = await contract.write.setUint([50n])
    console.log('Transaction hash:', hash)

    // トランザクションの確認
    const receipt = await publicClient.waitForTransactionReceipt({ hash })
    console.log('Transaction status:', receipt.status)
    console.log('Block number:', receipt.blockNumber.toString(), '\n')

    // 5. 更新後の値を確認
    console.log('--- Reading updated value ---')
    const updatedValue = await contract.read.myUint()
    console.log('Updated myUint value:', updatedValue.toString())
  }

  // スクリプトとして実行された場合
  if (import.meta.url === `file://${process.argv[1]}`) {
    main().catch(console.error)
  }

  // エクスポート
  export { contractABI, contractAddress, publicClient, walletClient }
