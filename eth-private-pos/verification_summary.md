# 動作確認サマリー（2025-12-04）

## 実行内容
process2.mdの更新版に従って、staking-deposit-cliでキーストアを生成し、deposit_data.jsonを使用してgenesis.sszを作成するフローを実行しました。

## 成功した項目 ✅
1. **staking-deposit-cliでのキーストア生成**: 正常に動作し、keystoreファイルとdeposit_data.jsonが生成されました
2. **Geth**: 正常に初期化・起動し、JSON-RPC APIが動作しています
3. **ウォレット作成とキーインポート**: dist/validator-v7.0.0-linux-amd64を使用して、キーストアを正常にインポートできました（アカウント数: 1件）
4. **Validatorアカウント確認**: `accounts list`で公開鍵 0xa73febe4f241... が表示され、キーが認識されていることを確認

## 発見された問題 ⚠️

### 1. Genesis Time問題（重要）
**問題**: `prysmctl testnet generate-genesis --deposit-json-file`を使用すると、genesis timeがmainnetのデフォルト値（2020-12-01 13:00:23）になります。

**詳細**:
- `--genesis-time-delay 60`オプションを指定しても無視される
- deposit_data.jsonにはgenesis_timeフィールドが含まれていない
- prysmctlが内部でmainnetのデフォルトgenesis timeを使用している模様

**影響**:
- Beacon Chainが起動しても、genesis timeが過去すぎるため、ネットワークが正常に機能しない
- バリデータが「次のエポックまで待機」状態になる

### 2. Validator接続エラー
**問題**: Validatorから Beacon ChainのgRPCポート（localhost:4000）への接続で"socket: operation not permitted"エラーが発生

**詳細**:
```
Failed to get health of node: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing: dial tcp 127.0.0.1:4000: socket: operation not permitted"
```

**考えられる原因**:
- WSL2環境のネットワーク制約
- ファイアウォール設定
- SELinuxやAppArmorなどのセキュリティポリシー

## 推奨される解決策

### Genesis Time問題の解決策
deposit_data.jsonを使用せず、`--num-validators 1`のみでgenesis.sszを生成する方が、現在時刻を基準にした正しいgenesis timeが設定されます。

ただし、この方法では以下の制約があります:
- prysmctlが内部でランダムなキーペアを生成するため、staking-deposit-cliで生成したキーストアと不一致になる
- Validatorは「No validating keys fetched」エラーになる

### 根本的な解決策
プライベートネットワークでPrysmを使用する場合、以下のいずれかのアプローチが必要です:

1. **Web3Signerを使用**: prysmctlが生成したキーを抽出してWeb3Signerに登録する
2. **別のコンセンサスクライアント**: deposit_data.jsonから正しくgenesis timeを設定できるクライアントを使用
3. **Prysmのソースコード修正**: deposit_data.json使用時のgenesis time処理を修正

## まとめ
Codexが提案したフロー（staking-deposit-cli → deposit_data.json → genesis.ssz）は、キーストアの生成・インポートという点では正常に機能しました。しかし、prysmctlの`--deposit-json-file`オプションがgenesis timeを正しく処理しない問題により、プライベートネットワークとしては使用できない状態です。

現時点では、process2.mdのセクション14.4に記載した通り、prysmctlの`--num-validators`オプションのみを使用する従来の方法が最も確実です（キーのバックアップができないという制約はありますが）。

## 更新されたドキュメント
[process2.md](process2.md:753) のセクション14.4を更新し、以下を記載しました:
- 動作確認結果の詳細
- 発見された問題の説明
- 推奨される対策
