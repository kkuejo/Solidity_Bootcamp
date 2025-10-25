前提条件
1. Node.jsとnpmがインストール済み
2. Foundyをインストール済み。まだの場合は以下のコマンドを実行
　  # Foundryのインストール
    curl -L https://foundry.paradigm.xyz | bash
    foundryup

ステップバイステップ手順
1. # Node.jsプロジェクトの初期化
    npm init -y
2. # Viemのインストール
    npm install viem
3. # Anvilを起動（ローカルEthereumノード）
    anvil

Anvilが起動すると、以下のような情報が表示されます：

デフォルトポート: http://127.0.0.1:8545
10個のテストアカウント（各10,000 ETH）
各アカウントの秘密鍵

4. Balance.jsを作成

5. 実行
    %node Balance.js

6. send-transaction.jsを作成

7. 実行
    %node send-transaction.js

8. index.jsを作成

9. 実行
    %node index.js

Java ScriptからType Scriptへの以降手順
1. 必要なパッケージをインストール
    #高速なtsxを使う
    npm install --save-dev tsx
2. プロジェクトルートにtsconfig.jsonを作成
3. srcフォルダの作成
4. balance_ts.tsの作成
5. 実行
    npx tsx src/balance_ts.ts 
6. send-transaction_ts.tsの作成
    npx tsx src/send-transaction_ts.ts 
8. index_ts.tsの作成
    npx tsx src/index_ts.ts
