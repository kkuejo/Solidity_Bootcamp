１. 作成するプロジェクト

viem/
├── foundry/              # Foundryプロジェクト
│   ├── src/
│   │   └── SomeContract.sol
│   ├── script/
│   │   └── Deploy.s.sol
│   └── foundry.toml
├── src/                  # TypeScriptコード
│   ├── deploy.ts
│   └── contract-interaction.ts
├── package.json
└── tsconfig.json

2. プロジェクトのセットアップ

2.1 Foundryプロジェクトの作成
    # Foundryプロジェクトの初期化
    forge init foundry --no-git

    npm init -y
    npm install viem
    npm install --save-dev tsx typescript @types/node

2.2 tsconfig.jsonの作成

3. スマートコントラクトの作成

3.1 スマートコントラクト、foundry/src/SomeContract.solの作成
3.2 コントラクトのコンパイル
　　 cd foundry
    forge build
    cd ..
3.3 デプロイスクリプト、foundry/script/Deploy.s.solの作成

4. Anvilの起動とデプロイ
4.1 Anvilの起動
    %anvil
4.2 Foundyでデプロイ
    %cd foundry
    %forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
    %cd ..


    デプロイされたコントラクトアドレスを確認。
    0x0DCd1Bf9A1b36cE34237eEaFef220932846BCD82

5. TypeScriptでコントラクトとコミュニケーション
5.1  src/contract-interaction.tsの作成
5.2 デプロイスクリプト、src/deploy.tsの作成
5.3 package.jsonにscriptsを追加

6. 以下の開発フローが完成
6.1 Anvilの起動
    %anvil
6.2 コントラクトを編集
    # foundry/src/SomeContract.sol を編集
6.3 コンパイル
    cd foundry && forge build && cd ..
6.4 デプロイ
    npx tsx src/deploy.ts
6.4 対話（読み取り、書き込み）
    npx tsx src/contract-interaction.ts

7 関数セレクター
7.1 src/function-selector.tsの作成
7.2  実行
    npx tsx src/contract-interaction.ts

8 より実践的な例（ABIファイルを使用）
8.1 src/with-abi-file.tsの作成
8.2 実行
    npx tsx src/with-abi-file.ts