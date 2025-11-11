import { 
  createPublicClient, 
  createWalletClient, 
  http, 
  parseAbi, 
  defineChain,
  type PublicClient,
  type Address,
  type Hash
} from 'viem'
import { privateKeyToAccount } from 'viem/accounts'

// Anvilのチェーン設定（chain ID: 31337）
const anvil = defineChain({
  id: 31337,
  name: 'Anvil Localhost',
  nativeCurrency: {
      decimals: 18,
      name: 'Ether',
      symbol: 'ETH',
  },
  rpcUrls: {
      default: {
          http: ['http://127.0.0.1:8545'],
      },
  },
})

// コントラクト設定（デプロイしたアドレスに置き換えてください）
const CONTRACT_ADDRESS: Address = '0x5fbdb2315678afecb367f032d93f642f64180aa3'

const contractABI = parseAbi([
  'function myUint() view returns (uint256)',
  'function setUint(uint256 _myUint) public'
])

// Anvilのデフォルトアカウント（最初のアカウント）
const account = privateKeyToAccount(
  '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
)

// Public Client（読み取り専用）
const publicClient: PublicClient = createPublicClient({
  chain: anvil,
  transport: http('http://localhost:8545')
})

// Wallet Client（書き込み用）
const walletClient = createWalletClient({
  account,
  chain: anvil,
  transport: http('http://localhost:8545')
})

// myUintを読み取る関数
async function readMyUint(): Promise<bigint | undefined> {
  try {
      const result = await publicClient.readContract({
          address: CONTRACT_ADDRESS,
          abi: contractABI,
          functionName: 'myUint'
      })
      console.log('myUint value:', result.toString())
      return result
  } catch (error) {
      console.error('Error reading myUint:', error)
      return undefined
  }
}

// myUintを更新する関数
async function updateMyUint(newValue: number | bigint): Promise<bigint | undefined> {
  try {
      console.log(`Updating myUint to ${newValue}...`)
      
      // トランザクション送信
      const hash: Hash = await walletClient.writeContract({
          address: CONTRACT_ADDRESS,
          abi: contractABI,
          functionName: 'setUint',
          args: [BigInt(newValue)]
      })
      
      console.log('Transaction hash:', hash)
      
      // トランザクションの確認を待つ
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      console.log('Transaction confirmed!', receipt)
      
      // 更新された値を読み取る
      const updatedValue = await readMyUint()
      return updatedValue
  } catch (error) {
      console.error('Error updating myUint:', error)
      return undefined
  }
}

// アカウント情報を取得
async function getAccounts(): Promise<Address[]> {
  // privateKeyToAccountで作成したアカウントを使用
  const accounts: Address[] = [account.address]
  console.log('Available accounts:', accounts)
  console.log('Using account:', account.address)
  return accounts
}

// グローバルに関数を公開（ブラウザコンソールから使えるように）
declare global {
  interface Window {
      readMyUint: typeof readMyUint;
      updateMyUint: typeof updateMyUint;
      getAccounts: typeof getAccounts;
      publicClient: typeof publicClient;
      walletClient: typeof walletClient;
      CONTRACT_ADDRESS: Address;
  }
}

window.readMyUint = readMyUint
window.updateMyUint = updateMyUint
window.getAccounts = getAccounts
window.publicClient = publicClient
window.walletClient = walletClient
window.CONTRACT_ADDRESS = CONTRACT_ADDRESS

// 初期化メッセージ
console.log('✅ Viem setup complete!')
console.log('📝 Contract address:', CONTRACT_ADDRESS)
console.log('👤 Using account:', account.address)
console.log('🌐 Chain:', anvil.name)
console.log('')
console.log('Try these commands:')
console.log('  await readMyUint()')
console.log('  await updateMyUint(50)')
console.log('  await getAccounts()')