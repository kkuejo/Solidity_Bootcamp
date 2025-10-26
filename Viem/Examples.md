1.0 読み取り操作
// 1. 状態変数の読み取り
const balance = await contract.read.balanceOf(['0xAddress'])
const totalSupply = await contract.read.totalSupply()
const owner = await contract.read.owner()

// 2. 複雑な計算結果の取得
const price = await contract.read.calculatePrice([amount, tokenType])

// 3. 配列やマッピングのデータ
const tokenId = await contract.read.tokenByIndex([0])

// 4. 条件チェック
const isApproved = await contract.read.isApprovedForAll([owner, operator])


1.1 読み取り操作の例(ERC20トークン)
// 残高確認
const myBalance = await contract.read.balanceOf(['0xMyAddress'])
console.log(`残高: ${formatEther(myBalance)} tokens`)

// 総供給量
const total = await contract.read.totalSupply()
console.log(`総供給量: ${formatEther(total)} tokens`)

// 名前とシンボル
const name = await contract.read.name()
const symbol = await contract.read.symbol()
console.log(`${name} (${symbol})`)

2.0 書き込み操作
// 1. 値の更新
await contract.write.setUint([50n])
await contract.write.updateName(['New Name'])

// 2. トークンの送信
await contract.write.transfer(['0xRecipient', parseEther('10')])

// 3. 承認（Approval）
await contract.write.approve(['0xSpender', parseEther('100')])

// 4. NFTのミント
await contract.write.mint(['0xTo', tokenId])

// 5. 複雑な操作
await contract.write.swap([tokenIn, tokenOut, amountIn, minAmountOut])

2.1 書き込み操作の例(ERC-20トークンの送信)
// 10トークンを送信
const hash = await contract.write.transfer([
  '0xRecipientAddress',
  parseEther('10')
])

console.log('Transaction hash:', hash)

// トランザクション確認を待つ
const receipt = await publicClient.waitForTransactionReceipt({ hash })
console.log('Status:', receipt.status) // 'success' or 'reverted'

3.0 ETHと一緒に送信
// NFTを購入（0.1 ETH支払い）
await contract.write.buyNFT([tokenId], {
  value: parseEther('0.1')
})

// ステーキング（1 ETH預ける）
await contract.write.stake([], {
  value: parseEther('1')
})

4.0 イベントの監視
// 過去のイベント取得
const logs = await publicClient.getContractEvents({
  address: contractAddress,
  abi: contractABI,
  eventName: 'Transfer',
  fromBlock: 1000000n,
  toBlock: 'latest'
})

console.log('過去の送金履歴:', logs)

// リアルタイムでイベント監視
const unwatch = publicClient.watchContractEvent({
  address: contractAddress,
  abi: contractABI,
  eventName: 'Transfer',
  onLogs: (logs) => {
    logs.forEach(log => {
      console.log(`送金: ${log.args.from} → ${log.args.to}`)
      console.log(`金額: ${formatEther(log.args.value)}`)
    })
  }
})

// 監視停止
// unwatch()

5.0 DEXでの取引例
// 1. 現在の価格を確認（読み取り）
const price = await dexContract.read.getPrice(['USDC', 'ETH'])
console.log(`1 ETH = ${price} USDC`)

// 2. 自分の残高を確認（読み取り）
const usdcBalance = await usdcContract.read.balanceOf([myAddress])
console.log(`USDC残高: ${formatUnits(usdcBalance, 6)}`)

// 3. DEXにUSDCの使用許可を与える（書き込み）
const approveHash = await usdcContract.write.approve([
  dexAddress,
  parseUnits('1000', 6) // 1000 USDC
])
await publicClient.waitForTransactionReceipt({ hash: approveHash })

// 4. スワップを実行（書き込み）
const swapHash = await dexContract.write.swap([
  'USDC',
  'ETH',
  parseUnits('1000', 6), // 1000 USDC
  parseEther('0.4')      // 最低0.4 ETH受取
])
await publicClient.waitForTransactionReceipt({ hash: swapHash })

// 5. 結果を確認（読み取り）
const newBalance = await publicClient.getBalance({ address: myAddress })
console.log(`新しいETH残高: ${formatEther(newBalance)}`)

6.0 NFTマーケットプレイス
// 1. NFTが販売中か確認（読み取り）
const listing = await marketContract.read.getListing([tokenId])
console.log(`価格: ${formatEther(listing.price)} ETH`)
console.log(`販売者: ${listing.seller}`)

// 2. 自分のETH残高を確認（読み取り）
const balance = await publicClient.getBalance({ address: myAddress })

if (balance < listing.price) {
  console.log('残高不足')
  return
}

// 3. NFTを購入（書き込み + ETH送信）
const hash = await marketContract.write.buyNFT([tokenId], {
  value: listing.price
})

await publicClient.waitForTransactionReceipt({ hash })

// 4. NFTの所有権を確認（読み取り）
const owner = await nftContract.read.ownerOf([tokenId])
console.log(`新しいオーナー: ${owner}`)
console.log(`購入成功: ${owner === myAddress}`)

7.0 DeFiレンディング
// 1. 現在のAPY（年利）を確認（読み取り）
const apy = await lendingContract.read.getSupplyAPY()
console.log(`供給APY: ${apy / 100}%`)

// 2. 自分の預金額を確認（読み取り）
const deposited = await lendingContract.read.balanceOf([myAddress])
console.log(`預金: ${formatEther(deposited)} ETH`)

// 3. 追加で預金（書き込み + ETH送信）
const depositHash = await lendingContract.write.deposit([], {
  value: parseEther('5') // 5 ETH預ける
})
await publicClient.waitForTransactionReceipt({ hash: depositHash })

// 4. 利息を確認（読み取り）
const interest = await lendingContract.read.getAccruedInterest([myAddress])
console.log(`獲得利息: ${formatEther(interest)} ETH`)

// 5. 引き出し（書き込み）
const withdrawHash = await lendingContract.write.withdraw([
  parseEther('2') // 2 ETH引き出す
])
await publicClient.waitForTransactionReceipt({ hash: withdrawHash })


できることのまとめ
📊 データ取得

✅ 残高、価格、数量の確認
✅ 所有権の確認
✅ 利率、手数料の計算
✅ 状態の確認（承認済みか、有効か等）

💸 資産操作

✅ トークンの送信・受信
✅ NFTの転送・ミント
✅ トークンの交換（スワップ）
✅ ステーキング・アンステーキング

🔐 承認・許可

✅ トークン使用許可（Approval）
✅ オペレーター設定
✅ 権限の委譲

💰 金融操作

✅ 預金・引き出し
✅ 借入・返済
✅ 報酬の請求
✅ 手数料の支払い

🎮 ゲーム・アプリ

✅ ゲームアイテムの使用
✅ キャラクターのレベルアップ
✅ クエストの完了
✅ 投票・ガバナンス

📢 イベント追跡

✅ 過去のトランザクション履歴
✅ リアルタイム通知
✅ 価格変動の監視
✅ 活動ログの取得


制限事項
❌ できないこと:

プライベート変数の直接読み取り
他人のウォレットからの送信（秘密鍵が必要）
トランザクションの取り消し（一度送信したら不可逆）
ガス代なしでの状態変更