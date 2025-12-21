# Anvilへのデプロイ手順

このドキュメントでは、MyTokenコントラクトをAnvil（ローカルEthereumノード）にデプロイする方法を説明します。

## 前提条件

- Foundryがインストールされていること
- `.env.example`ファイルがあること

## ステップ1: 環境変数ファイルの作成

`.env.example`をコピーして`.env`ファイルを作成します：

```bash
cp .env.example .env
```

`.env`ファイルを編集して、Anvilのデフォルト秘密鍵を設定します：

```bash
# Anvilのデフォルトアカウントの秘密鍵を使用
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# 初期トークン供給量（オプション、デフォルト: 1000000）
INITIAL_TOKENS=1000000
```

**重要**: `.env`ファイルは`.gitignore`に含まれているため、リポジトリにコミットされません。

## ステップ2: Anvilを起動

新しいターミナルウィンドウを開き、Anvilを起動します：

```bash
anvil
```

Anvilが起動すると、以下のような情報が表示されます：

```
Available Accounts
==================
(0) 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)

Private Keys
==================
(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

...

Listening on 127.0.0.1:8545
```

このターミナルは開いたままにしておきます。

## ステップ3: コントラクトをデプロイ

別のターミナルウィンドウで、以下のコマンドを実行してデプロイします：

```bash
# 環境変数を読み込んでデプロイ
source .env
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key $PRIVATE_KEY
```

または、環境変数を使わずに直接指定することもできます：

```bash
forge script script/Deploy.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## ステップ4: デプロイ結果の確認

デプロイが成功すると、以下のような情報が表示されます：

```
=== Deployment Started ===
Deployer address: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Initial token supply: 1000000

=== MyToken Deployed ===
Contract address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Token name: StarDucks Cappucino Token
Token symbol: CAPPU
Decimals: 0
Total supply: 1000000
Owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Recipient balance: 1000000

=== Deployment Summary ===
MyToken: 0x5FbDB2315678afecb367f032d93F642f64180aa3
========================
```

Anvilのターミナルにも、トランザクションの詳細が表示されます。

## デプロイ済みコントラクトとの対話

デプロイ後、`cast`コマンドを使ってコントラクトと対話できます：

```bash
# コントラクトアドレスを変数に保存
export CONTRACT_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3

# トークン名を取得
cast call $CONTRACT_ADDRESS "name()(string)" --rpc-url http://127.0.0.1:8545

# 総供給量を取得
cast call $CONTRACT_ADDRESS "totalSupply()(uint256)" --rpc-url http://127.0.0.1:8545

# デプロイヤーの残高を確認
cast call $CONTRACT_ADDRESS "balanceOf(address)(uint256)" \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 \
  --rpc-url http://127.0.0.1:8545
```

## トラブルシューティング

### エラー: "environment variable PRIVATE_KEY not found"

`.env`ファイルが正しく作成されていないか、環境変数が読み込まれていません。

解決方法：
```bash
# .envファイルが存在するか確認
ls -la .env

# 環境変数を手動で設定
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### エラー: "connection refused" または "could not connect to http://127.0.0.1:8545"

Anvilが起動していない可能性があります。

解決方法：
- 別のターミナルで`anvil`コマンドを実行して、Anvilが起動していることを確認してください

### エラー: "insufficient funds"

Anvilのデフォルトアカウントには十分なETHがあるはずですが、何か問題がある場合は：

解決方法：
```bash
# Anvilを再起動
# または、Anvil起動時に特定のアカウントにETHを付与
anvil --balance 10000
```

## 次のステップ

- テストネット（Sepolia）へのデプロイ
- Mainnetへのデプロイ
- コントラクトの検証

詳細は`.env.example`ファイルのコメントを参照してください。
