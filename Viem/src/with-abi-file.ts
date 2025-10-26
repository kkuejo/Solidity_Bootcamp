// src/with-abi-file.ts
//getContractは、既にデプロイされているスマートコントラクトとやり取りするためのインスタンスを作成する関数
import { 
    createPublicClient, 
    createWalletClient, 
    http,
    getContract
  } from 'viem'
  import { foundry } from 'viem/chains'
  import { privateKeyToAccount } from 'viem/accounts'
  import type { Address } from 'viem'
  //Foundryのコンパイル結果のJSONをインポート
  import contractJson from '../foundry/out/SomeContract.sol/SomeContract.json'
  
  //SomeContractのコントラクトアドレス
  const contractAddress: Address = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
  
  const publicClient = createPublicClient({
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  //AnvilのAccount #0の秘密鍵
  const account = privateKeyToAccount(
    '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
  )
  
  const walletClient = createWalletClient({
    account,
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  async function main() {
    // FoundryのJSON出力からABIを取得
    //getContractは、既にデプロイされているスマートコントラクトとやり取りするためのインスタンスを作成する関数
    const contract = getContract({
      address: contractAddress,
      abi: contractJson.abi,
      //public: publicClient, wallet: walletClientは、publicClientとwalletClientを使用して、コントラクトとやり取りする。
      //public: publicClientは、読み取り専用のクライアント
      //wallet: walletClientは、書き込み用のクライアント
      client: { public: publicClient, wallet: walletClient }
    })
  
    // 読み取り
    console.log('Reading myUint...')
    const value = await contract.read.myUint() as bigint
    console.log('Current value:', value.toString())
  
    // 書き込み
    console.log('\nUpdating to 100...')
    //bigintは、整数を表す型
    //100nは、100をbigintに変換する。
    const hash = await contract.write.setUint([100n])
    await publicClient.waitForTransactionReceipt({ hash })
    
    // 確認
    const newValue = await contract.read.myUint() as bigint
    console.log('New value:', newValue.toString())
  }
  
  main().catch(console.error)