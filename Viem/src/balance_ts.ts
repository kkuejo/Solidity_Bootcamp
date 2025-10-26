// src/balance.ts
import { createPublicClient, http } from 'viem'
import { foundry } from 'viem/chains'
//型安全の為、Address型を使用する。
//Address型は、Ethereumのアドレスを表す型である。
//address型は、実行時にはstring型として扱われ為、string型として扱うことができる。
import type { Address } from 'viem'

// Public Clientの作成（読み取り専用）
const publicClient = createPublicClient({
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
})

// アカウントの残高を取得
// AnvilのAccount #0のアドレスを使用
const address: Address = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'
//const address = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'
const balance = await publicClient.getBalance({ 
  address: address 
})

console.log('Balance:', balance.toString(), 'Wei')
console.log('Balance:', (balance / BigInt(10**18)).toString(), 'ETH')