forge createとforge scriptの違いを区別した。
良い質問です！forge create には --broadcast は不要です。

forge create と forge script の違い
1. forge create（コントラクトのデプロイ専用）
bash
forge create src/SomeContract.sol:SomeContract \
  --rpc-url http://localhost:8545 \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
--broadcast は不要
デフォルトで実際にトランザクションを送信
シンプルで直接的なデプロイに使用
1つのコントラクトをデプロイするだけ
2. forge script（スクリプト実行）
bash
forge script script/Interact.s.sol \
  --rpc-url http://localhost:8545 \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
  --broadcast  # ← これが必要！
--broadcast が必要
--broadcast なし = シミュレーションのみ（dry run）
--broadcast あり = 実際にトランザクション送信
複雑なデプロイやインタラクションに使用