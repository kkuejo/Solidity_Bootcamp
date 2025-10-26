// src/deploy.ts
import { 
    createPublicClient, 
    createWalletClient, 
    http 
  } from 'viem'
  import { foundry } from 'viem/chains'
  import { privateKeyToAccount } from 'viem/accounts'
  //Foundryのコンパイル結果のJSONをインポート
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
    //3つの引数が必須: abi, bytecode, account
    const hash = await walletClient.deployContract({
      //abiを渡し、対話に必要な関数シグネチャ(関数名と引数の型で、関数を一意に識別するための文字列表現)・引数・戻り値の型を指定します。
      abi: contractJson.abi,
      //bytecode.objectは、コントラクトのバイトコードを含む文字列
      //デプロイ用のコントラクトコード(コンパイル時に生成)、コンストラクタ、メタデータ(コンパイラバージョン)等が含まれている。
      //型キャストしておいて、型安全性を確保する。
      bytecode: contractJson.bytecode.object as `0x${string}`,
      //トランザクションに署名し、ガスの支払い元となるアカウントを指定します。
      account
    })
  
    console.log('Transaction hash:', hash)
  
    // デプロイ完了を待つ
    //hashが検証されブロックに取り込まれるまで、プログラムの実行を停止する。
    const receipt = await publicClient.waitForTransactionReceipt({ hash })
    
    console.log('Contract deployed at:', receipt.contractAddress)
    console.log('Block number:', receipt.blockNumber.toString())
  
    return receipt.contractAddress
  }
  
console.log('スクリプト開始...')
deploy().catch(error => {
  console.error('実行エラー:', error)
})