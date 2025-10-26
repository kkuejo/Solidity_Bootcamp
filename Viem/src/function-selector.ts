// src/function-selector.ts
//ABI無しで低レベルAPIを使用し、コントラクトを呼び出す場合
//バイトコードを直接生成する場合
//バイトコードを直接生成する場合などに、function-selector.tsを使用する。

//keccak256は、入力をハッシュに変換する関数
//toBytesは、文字列をバイト配列に変換する
import { keccak256, toBytes } from 'viem'

// 関数シグネチャからセレクターを生成
function getFunctionSelector(signature: string): string {
  const bytes = toBytes(signature)
  const hash = keccak256(bytes)
  return hash.slice(0, 10) // 最初の4バイト（0x + 8文字）
}

console.log('myUint() selector:', getFunctionSelector('myUint()'))
// 出力: 0x06540f7e

console.log('setUint(uint256) selector:', getFunctionSelector('setUint(uint256)'))
// 出力: 0x9bfad821