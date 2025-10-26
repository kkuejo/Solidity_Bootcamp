/*
createWalletClient
役割: Ethereumブロックチェーンとの書き込み専用の接続を作成
用途: トランザクション送信、スマートコントラクトの実行など
特徴: 秘密鍵が必要（書き込み権限のため）

parseEther
役割: ETH単位の値をWei単位に変換
用途: トランザクションのvalueフィールドに使用
例: parseEther('1') → 1000000000000000000n (1 ETH = 10^18 Wei)
*/

import { createWalletClient, createPublicClient, http, parseEther } from 'viem';
import { foundry } from 'viem/chains';

/*
privateKeyToAccountの詳細
役割
秘密鍵からアカウントオブジェクトを作成
署名機能を提供
ウォレット操作に必要な情報を管理
*/
import { privateKeyToAccount } from 'viem/accounts';

// Anvilから取得した秘密鍵を使用（Account #0）
const account = privateKeyToAccount('0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80');

// Wallet Clientの作成（書き込み用）
//accountはプロパティ名と変数が同じであるため、「account: account」とはせず、「account」とES6の短縮構文を使用する。
const walletClient = createWalletClient({
  account,
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
});

// Public Clientの作成（読み取り用）
const publicClient = createPublicClient({
  chain: foundry,
  transport: http('http://127.0.0.1:8545')
});

// Account #0 から Account #1 に 1 ETH送信
const hash = await walletClient.sendTransaction({
  to: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8', // Account #1
  value: parseEther('1') // 1 ETH
});

console.log('Transaction Hash:', hash);

// トランザクションの確認を待つ
// トランザクションの確認を待つために、publicClient.waitForTransactionReceipt()は非同期関数となっている。
//publicClient.waitForTransactionReceipt()は、hashが検証されブロックに取り込まれるまで、プログラムの実行を停止する。
// (Ethereumのメインネットでは、12秒置きにPOWの検証作業が行われるので、最大12秒待つ必要がある。)
/* receiptの主要フィールドは以下の通り。
status
"success": トランザクションが正常に実行された
"reverted": トランザクションが失敗した
blockNumber
役割: トランザクションが含まれたブロック番号
例: 4n (BigInt)
transactionHash
役割: トランザクションのハッシュ値
例: "0x46abbb9e66ebddabf14fb9fc1f2a4810fdb66d59d9461f993d946f715126fa63"
*/
const receipt = await publicClient.waitForTransactionReceipt({ hash });
console.log('Transaction Status:', receipt.status);