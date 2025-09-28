npm init -y
npm install --save-dev hardhat
npx hardhat --init

A TypeScript Hardhat project using Node Test Runner and Viem

npx hardhat test (unit test)
npx hardhat compile

コンパイルすることにより、artifactsフォルダができる。
contractsの中のjsonファイルには、abiとbytecodeなどの必要な情報が入っている。

build infoの中にはソースコードのコピーが入っている。


npx hardhat nodeで開発用のローカルブロックチェーンを起動。

npx hardhat run --network localhost scripts/send-op-tx.ts でローカルネットワーク上でOptimismスタイルのトランザクションをテスト実行


