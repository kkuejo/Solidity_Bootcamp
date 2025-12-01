A. フェーズ１: スマートコントラクトの構築

1. # Foundryプロジェクト初期化
    forge init contracts
    cd contracts

2. # OpenZeppelinのインストール
    2.1 forge install OpenZeppelin/openzeppelin-contracts
    2.2 foundry.tomlに記述
        [profile.default]
    src = "src"
    out = "out"
    libs = ["lib"]
    solc_version = "0.8.20"
    remappings = [
        "@openzeppelin/=lib/openzeppelin-contracts/"
    ]

3. スマートコントラクトの作成
　  src/Ownable.sol
    src/Item.sol
    src/ItemManager.sol

4. テストスクリプトの作成
    test/ItemManager.t.sol

5. デプロイスクリプトの作成
    script/Deploy.s.sol

6. テストの実行
    cd contracts
    forge test -vv

7. Anvilの起動
    anvil

8. Anvilにデプロイ
    cd contracts
    forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast

B: フロントエンド開発
9. フロントエンドプロジェクト作成
    cd ..
    npm create vite@latest frontend -- --template react-ts
    cd frontend
    npm install 

10. 必要なパッケージインストール
    npm install viem wagmi @wagmi/core @wagmi/connectors
    npm install @tanstack/react-query

11. ABIファイルのコピー
    mkdir -p src/contracts　(親ディレクトリsrcがない場合にそれを作成するための-pオプション)
    cp ../contracts/out/ItemManager.sol/ItemManager.json src/contracts/
    cp ../contracts/out/Item.sol/Item.json src/contracts/

12. フロントエンドのファイル
    src/wagmi.config.ts
    src/App.tsx
    src/components/SupplyChain.tsx
    .envにVITE_ITEM_MANAGER_ADDRESS=0x... # Anvilでデプロイしたアドレス

13. フロントエンドの実行
    npm run dev

14.http://localhost:5175/を開く


