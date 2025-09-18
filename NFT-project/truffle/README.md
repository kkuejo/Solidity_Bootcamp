# Spacebear NFT Contract - Deployment and Interaction Guide

## 概要
このプロジェクトは、ERC721標準に準拠したSpacebear NFTコントラクトをGanacheローカルネットワークにデプロイし、対話するためのものです。

## 前提条件
- Node.js (v18またはv20推奨、v22でも動作可能)
- npm
- Truffle
- Ganache

## セットアップ

### 1. 依存関係のインストール
```bash
npm install
```

### 2. Ganacheの起動
別のターミナルでGanacheを起動します：
```bash
npx ganache
```

デフォルトでは以下の設定で起動します：
- Host: 127.0.0.1
- Port: 8545
- Network ID: *

## コントラクトのデプロイ

### 1. コンパイル
```bash
npx truffle compile
```

### 2. Ganacheネットワークへのデプロイ
```bash
npx truffle migrate --network ganache
```

デプロイ成功時には、以下のような出力が表示されます：
- Transaction hash
- Contract address
- Gas used
- Total cost

## コントラクトとの対話

### 方法1: Truffle Console を使用

1. コンソールを起動：
```bash
npx truffle console --network ganache
```

2. コンソール内で以下のコマンドを実行：

```javascript
// コントラクトのインスタンスを取得
let spacebear = await Spacebear.deployed()

// 名前を取得（"Spacebear"が返される）
await spacebear.name()

// シンボルを取得（"SBR"が返される）
await spacebear.symbol()

// コントラクトアドレスを確認
spacebear.address

// オーナーアドレスを確認
await spacebear.owner()

// コンソールを終了
.exit
```

### 方法2: スクリプトを使用

テストスクリプトを作成して実行：

1. `interact.js`ファイルを作成：
```javascript
const Spacebear = artifacts.require("Spacebear");

module.exports = async function(callback) {
    try {
        const spacebear = await Spacebear.deployed();
        console.log("Contract address:", spacebear.address);
        console.log("Contract name:", await spacebear.name());
        console.log("Contract symbol:", await spacebear.symbol());
        console.log("Contract owner:", await spacebear.owner());
        callback();
    } catch (error) {
        console.error("Error:", error);
        callback(error);
    }
};
```

2. スクリプトを実行：
```bash
npx truffle exec interact.js --network ganache
```

## NFTのミント（Mint）と詳細確認

### NFTをミントする

Truffle Console内で以下のコマンドを実行：

```javascript
// コントラクトのインスタンスとアカウントを取得
let spacebear = await Spacebear.deployed()
const accounts = await web3.eth.getAccounts()

// NFTをミント（accounts[1]にspacebear_1.jsonをミント）
// 注意: safeMintはオーナー（accounts[0]）のみが実行可能
await spacebear.safeMint(accounts[1], "spacebear_1.json")

// 返り値にはトランザクション情報が含まれます
// トランザクションハッシュやイベントログを確認できます
```

### ミントされたNFTの詳細を確認

```javascript
// NFTの所有者を確認（tokenId: 0の所有者を取得）
await spacebear.ownerOf(0)
// → accounts[1]のアドレスが返される

// NFTのメタデータURIを確認
await spacebear.tokenURI(0)
// → "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_1.json"が返される

// 複数のNFTをミントした場合の例
await spacebear.safeMint(accounts[2], "spacebear_2.json")  // tokenId: 1
await spacebear.safeMint(accounts[3], "spacebear_3.json")  // tokenId: 2

// それぞれのNFTの所有者を確認
await spacebear.ownerOf(1)  // → accounts[2]
await spacebear.ownerOf(2)  // → accounts[3]

// それぞれのトークンURIを確認
await spacebear.tokenURI(1)  // → ベースURI + "spacebear_2.json"
await spacebear.tokenURI(2)  // → ベースURI + "spacebear_3.json"
```

### その他の便利なコマンド

```javascript
// 特定アドレスが所有するNFTの数を確認
await spacebear.balanceOf(accounts[1])

// NFTの転送（accounts[1]からaccounts[2]へtokenId:0を転送）
// 注意: 転送はトークンの所有者のみが実行可能
await spacebear.transferFrom(accounts[1], accounts[2], 0, {from: accounts[1]})

// 転送後の所有者を確認
await spacebear.ownerOf(0)  // → accounts[2]
```

## プロジェクト構成

```
truffle/
├── contracts/
│   └── Spacebear.sol          # NFTコントラクト
├── migrations/
│   └── 01-spacebear-deployment.js  # デプロイスクリプト
├── test/                       # テストファイル
├── build/                      # コンパイル済みコントラクト
├── truffle-config.js          # Truffle設定ファイル
├── package.json               # NPM設定
└── README.md                  # このファイル
```

## トラブルシューティング

### Node.js v22使用時の警告
Node.js v22を使用している場合、以下の警告が表示されることがあります：
```
This version of µWS is not compatible with your Node.js build
```
この警告は無視しても問題ありません。デプロイと実行は正常に動作します。

### Ganacheに接続できない場合
1. Ganacheが起動していることを確認
2. `truffle-config.js`のネットワーク設定を確認
3. ポート8545が他のプロセスで使用されていないか確認

## 注意事項
- `initialOwner`はデプロイ時に自動的に設定されます（`accounts[0]`）
- NFTのミントは`onlyOwner`修飾子により、オーナーのみが実行可能
- ベースURIは`https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/`に設定