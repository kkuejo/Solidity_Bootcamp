// src/function-selector.ts
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