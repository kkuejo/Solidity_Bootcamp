# Sepolia接続ガイド

## 方法1: Truffle Dashboard（推奨 - 最も安定）

Truffle Dashboardを使用することで、レート制限やタイムアウトエラーを回避できます。

### 手順:

1. **ターミナル1で Truffle Dashboard を起動:**
   ```bash
   truffle dashboard
   ```
   ブラウザが自動的に開きます（http://localhost:24012）

2. **ブラウザでMetaMaskに接続:**
   - MetaMaskでSepoliaネットワークを選択
   - Truffle Dashboardページで「Connect Wallet」をクリック
   - MetaMaskで接続を承認

3. **ターミナル2で Truffle Console を起動:**
   ```bash
   truffle console --network dashboard
   ```

これでSepoliaネットワークに安定して接続できます。

## 方法2: Infura直接接続

Infuraを使用した直接接続:
```bash
truffle console --network sepolia
```

この方法はInfuraの無料プランの場合、レート制限エラーが発生する可能性があります。

## トラブルシューティング

### µWS警告について
```
This version of µWS is not compatible with your Node.js build
```
この警告は無視して構いません。機能に影響はありません。

### PollingBlockTrackerエラーが発生する場合
Truffle Dashboard方法を使用してください。これが最も確実な方法です。