PoSネットワークでのJSON-RPC APIの使い方について説明します。
PoSネットワークでのJSON-RPC API

1. Gethへの接続（基本は同じ）
# IPCで接続（Linux/Mac）
geth attach /path/to/geth.ipc

# IPCで接続（Windows）
geth attach \\.\pipe\geth.ipc

# HTTPで接続
geth attach http://localhost:8545

2. アカウント作成（同じ）
// Gethコンソール内で
personal.newAccount()
// パスフレーズを入力するとアドレスが生成される

// アカウント一覧
eth.accounts

3. 基本的なJSON-RPC操作（Geth側）
// 同期状況の確認
eth.syncing

// 最新ブロック番号
eth.blockNumber

// 残高確認（Wei単位）
eth.getBalance(eth.accounts[0])

// ETH単位に変換
web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")

// トランザクション送信
eth.sendTransaction({
  from: eth.accounts[0],
  to: "0x...",
  value: web3.toWei(1, "ether")
})

4. PoS特有：Beacon Chain API（Prysm側）
PoSネットワークでは、Gethに加えてPrysmのBeacon APIも利用できます。
# Beacon Chain APIエンドポイント（デフォルト: http://localhost:3500）

# 同期状態の確認
curl http://localhost:3500/eth/v1/node/syncing

# バリデーター情報
curl http://localhost:3500/eth/v1/beacon/states/head/validators

# チェーン情報
curl http://localhost:3500/eth/v1/beacon/headers/head

5. web3.jsでの接続（PoSでも同じ）
const Web3 = require('web3');

// Geth（Execution Layer）に接続
const web3 = new Web3('http://localhost:8545');

// アカウント取得
const accounts = await web3.eth.getAccounts();

// 残高取得
const balance = await web3.eth.getBalance(accounts[0]);
console.log(web3.utils.fromWei(balance, 'ether'), 'ETH');