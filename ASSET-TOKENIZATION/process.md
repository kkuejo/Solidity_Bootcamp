1. Install Forge
forge init --force
forge install OpenZeppelin/openzeppelin-contracts

2. foundry.tomlの作成

3. MyToken.solの作成

4. MyToken.t.solの作成。
テストの実行は以下の通り。

# すべてのテストを実行
forge test

# 詳細な出力（-v, -vv, -vvv, -vvvv）
forge test -vvv

# 特定のテストのみ実行
forge test --match-test testTransfer

# 特定のコントラクトのみ
forge test --match-contract MyTokenTest

# ガス使用量レポート
forge test --gas-report

# カバレッジ
forge coverage

# Fuzz testの実行回数を増やす
forge test --fuzz-runs 10000

5.Deploy.s.solの作成
AnvilへのDeployの方法、トラブルシューティング、デプロイ後のコントラクトとの対話の方法についてはDEPLOY_ANVIL.mdを参照して下さい。


