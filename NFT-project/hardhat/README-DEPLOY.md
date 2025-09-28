# Sepoliaへのデプロイ方法

## 1. 環境変数の設定

`.env`ファイルを作成し、以下の環境変数を設定してください：

```bash
# .envファイルを作成
cp .env.example .env

# .envファイルを編集して以下を設定
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR-API-KEY
SEPOLIA_PRIVATE_KEY=0xYOUR-PRIVATE-KEY
```

### RPC URLの取得方法
1. [Alchemy](https://www.alchemy.com/)、[Infura](https://infura.io/)、または[QuickNode](https://www.quicknode.com/)でアカウントを作成
2. Sepoliaネットワーク用のAPIキーを取得
3. URLを`.env`ファイルに設定

### プライベートキーの取得方法
1. MetaMaskなどのウォレットから秘密鍵をエクスポート
2. **重要**: テストネット用の別アカウントを使用することを推奨

## 2. Sepolia ETHの取得

デプロイにはガス代として Sepolia ETH が必要です：
- [Sepolia Faucet](https://sepoliafaucet.com/)
- [Alchemy Sepolia Faucet](https://sepoliafaucet.com/)

## 3. デプロイの実行

環境変数を設定した後、以下のコマンドでデプロイできます：

```bash
# viemを使用したデプロイ
npx hardhat run scripts/deploy-counter-sepolia-viem.ts --network sepolia

# または ethersを使用したデプロイ
npx hardhat run scripts/deploy-counter.ts --network sepolia
```

## 環境変数を直接指定する方法

`.env`ファイルを作成せずに、コマンドラインで直接指定することも可能：

```bash
SEPOLIA_RPC_URL="https://eth-sepolia.g.alchemy.com/v2/YOUR-API-KEY" \
SEPOLIA_PRIVATE_KEY="0xYOUR-PRIVATE-KEY" \
npx hardhat run scripts/deploy-counter-sepolia-viem.ts --network sepolia
```