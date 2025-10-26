// src/write-contract.ts
import { 
    createPublicClient,
    createWalletClient, 
    http,
    parseAbi,
    parseEther
  } from 'viem'
  import { foundry } from 'viem/chains'
  import { privateKeyToAccount } from 'viem/accounts'
  import type { Address } from 'viem'
  
  // ===== 設定 =====
  
  // コントラクトアドレス（デプロイ後に更新してください）
  const CONTRACT_ADDRESS: Address = '0xc6e7df5e7b4f2a278906862b61205850344d4e7d'
  
  // コントラクトのABI
  const CONTRACT_ABI = parseAbi([
    'function myUint() public view returns (uint256)',
    'function setUint(uint256 _myUint) public'
  ])
  
  // Public Client（読み取り用）
  const publicClient = createPublicClient({
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  // AnvilのAccount #0の秘密鍵
  const account = privateKeyToAccount(
    '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
  )
  
  // Wallet Client（書き込み用）
  const walletClient = createWalletClient({
    account,
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  // ===== 書き込み関数 =====
  
  /**
   * 方法1: 基本的な書き込み
   */
  async function writeBasic() {
    console.log('--- 方法1: 基本的な書き込み ---')
    
    try {
      // 書き込み前の値を確認
      const beforeValue = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      console.log('書き込み前の値:', beforeValue.toString())
      
      // 値を更新
      const newValue = 50n
      console.log(`新しい値 ${newValue} に更新中...`)
      
      const hash = await walletClient.writeContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue]
      })
      
      console.log('トランザクションハッシュ:', hash)
      
      // トランザクションの確認を待つ
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      console.log('ステータス:', receipt.status) // 'success' or 'reverted'
      console.log('ブロック番号:', receipt.blockNumber.toString())
      console.log('使用ガス:', receipt.gasUsed.toString())
      
      // 書き込み後の値を確認
      const afterValue = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      console.log('書き込み後の値:', afterValue.toString())
      console.log()
      
      return { hash, receipt, afterValue }
    } catch (error) {
      console.error('書き込みエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法2: シミュレーション→書き込み（推奨）
   */
  async function writeWithSimulation() {
    console.log('--- 方法2: シミュレーション→書き込み（推奨） ---')
    
    try {
      const newValue = 100n
      
      // まずシミュレート（ガス代なし、エラーチェック）
      console.log('トランザクションをシミュレート中...')
      const { request } = await publicClient.simulateContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue],
        account
      })
      
      console.log('✅ シミュレーション成功（エラーなし）')
      
      // シミュレーション成功後に実行
      console.log('トランザクション送信中...')
      const hash = await walletClient.writeContract(request)
      
      console.log('トランザクションハッシュ:', hash)
      
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      console.log('✅ トランザクション確認完了')
      console.log('ステータス:', receipt.status)
      console.log()
      
      return { hash, receipt }
    } catch (error: any) {
      console.error('❌ エラー発生')
      
      if (error.message.includes('simulation')) {
        console.error('  シミュレーションで失敗しました')
        console.error('  このトランザクションは実行されません（ガス代節約）')
      }
      
      console.error('  詳細:', error.message)
      console.log()
      
      throw error
    }
  }
  
  /**
   * 方法3: 複数のトランザクションを連続実行
   */
  async function writeMultiple() {
    console.log('--- 方法3: 複数トランザクション ---')
    
    try {
      const values = [10n, 20n, 30n, 40n, 50n]
      
      for (let i = 0; i < values.length; i++) {
        const value = values[i]
        console.log(`\n[${i + 1}/${values.length}] 値を ${value} に更新中...`)
        
        const hash = await walletClient.writeContract({
          address: CONTRACT_ADDRESS,
          abi: CONTRACT_ABI,
          functionName: 'setUint',
          args: [value]
        })
        
        console.log('  TX:', hash.slice(0, 10) + '...')
        
        const receipt = await publicClient.waitForTransactionReceipt({ hash })
        console.log('  ✅ 完了 (Gas:', receipt.gasUsed.toString() + ')')
      }
      
      // 最終値を確認
      const finalValue = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      
      console.log('\n最終値:', finalValue.toString())
      console.log()
    } catch (error) {
      console.error('複数書き込みエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法4: ガス見積もり
   */
  async function writeWithGasEstimate() {
    console.log('--- 方法4: ガス見積もり ---')
    
    try {
      const newValue = 200n
      
      // ガス見積もり
      const gasEstimate = await publicClient.estimateContractGas({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue],
        account
      })
      
      console.log('推定ガス量:', gasEstimate.toString())
      
      // ガス価格を取得
      const gasPrice = await publicClient.getGasPrice()
      console.log('ガス価格:', gasPrice.toString(), 'wei')
      
      // 推定コスト（wei）
      const estimatedCost = gasEstimate * gasPrice
      console.log('推定コスト:', estimatedCost.toString(), 'wei')
      console.log('推定コスト:', Number(estimatedCost) / 1e18, 'ETH')
      
      // トランザクション実行
      console.log('\nトランザクション送信中...')
      const hash = await walletClient.writeContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue],
        gas: gasEstimate // オプション: 手動でガスリミットを指定
      })
      
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      
      console.log('実際のガス使用量:', receipt.gasUsed.toString())
      console.log('実際のコスト:', Number(receipt.gasUsed * gasPrice) / 1e18, 'ETH')
      console.log()
      
      return { gasEstimate, receipt }
    } catch (error) {
      console.error('ガス見積もりエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法5: エラーハンドリング
   */
  async function writeWithErrorHandling() {
    console.log('--- 方法5: エラーハンドリング ---')
    
    try {
      const newValue = 300n
      
      // シミュレート
      await publicClient.simulateContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue],
        account
      })
      
      // 書き込み
      const hash = await walletClient.writeContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue]
      })
      
      console.log('✅ トランザクション送信成功:', hash)
      
      // 確認（タイムアウト付き）
      const receipt = await publicClient.waitForTransactionReceipt({ 
        hash,
        timeout: 60_000 // 60秒でタイムアウト
      })
      
      if (receipt.status === 'success') {
        console.log('✅ トランザクション成功')
      } else {
        console.log('❌ トランザクション失敗（revert）')
      }
      
      console.log()
      return { success: true, hash, receipt }
    } catch (error: any) {
      console.error('❌ エラー発生')
      
      // エラーの種類を判定
      if (error.message.includes('insufficient funds')) {
        console.error('  原因: 残高不足')
        console.error('  解決: アカウントにETHを追加してください')
      } else if (error.message.includes('nonce')) {
        console.error('  原因: Nonce エラー')
        console.error('  解決: しばらく待ってから再試行してください')
      } else if (error.message.includes('gas')) {
        console.error('  原因: ガス不足')
        console.error('  解決: ガスリミットを増やしてください')
      } else if (error.message.includes('revert')) {
        console.error('  原因: コントラクトがトランザクションを拒否')
        console.error('  解決: コントラクトの条件を確認してください')
      } else {
        console.error('  詳細:', error.message)
      }
      
      console.log()
      return { success: false, error: error.message }
    }
  }
  
  /**
   * 方法6: トランザクションの詳細を追跡
   */
  async function writeWithTracking() {
    console.log('--- 方法6: トランザクション追跡 ---')
    
    try {
      const newValue = 999n
      
      console.log('📤 トランザクション送信前')
      console.log('  送信元:', account.address)
      console.log('  コントラクト:', CONTRACT_ADDRESS)
      console.log('  新しい値:', newValue.toString())
      
      const balanceBefore = await publicClient.getBalance({ 
        address: account.address 
      })
      console.log('  残高:', Number(balanceBefore) / 1e18, 'ETH\n')
      
      // 送信
      const hash = await walletClient.writeContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'setUint',
        args: [newValue]
      })
      
      console.log('⏳ トランザクション送信完了')
      console.log('  Hash:', hash)
      console.log('  確認待ち...\n')
      
      // 確認
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      
      console.log('✅ トランザクション確認完了')
      console.log('  ステータス:', receipt.status)
      console.log('  ブロック:', receipt.blockNumber.toString())
      console.log('  ガス使用:', receipt.gasUsed.toString())
      
      const balanceAfter = await publicClient.getBalance({ 
        address: account.address 
      })
      const cost = balanceBefore - balanceAfter
      console.log('  コスト:', Number(cost) / 1e18, 'ETH')
      console.log('  残高:', Number(balanceAfter) / 1e18, 'ETH\n')
      
      // トランザクション詳細を取得
      const transaction = await publicClient.getTransaction({ hash })
      console.log('📋 トランザクション詳細:')
      console.log('  From:', transaction.from)
      console.log('  To:', transaction.to)
      console.log('  Value:', transaction.value.toString(), 'wei')
      console.log('  Gas:', transaction.gas.toString())
      console.log()
      
      return { hash, receipt, transaction, cost }
    } catch (error) {
      console.error('追跡エラー:', error)
      throw error
    }
  }
  
  // ===== メイン実行関数 =====
  
  async function main() {
    console.log('='.repeat(60))
    console.log('✍️  スマートコントラクト書き込みサンプル')
    console.log('='.repeat(60))
    console.log()
    
    try {
      await writeBasic()
      await writeWithSimulation()
      await writeMultiple()
      await writeWithGasEstimate()
      await writeWithErrorHandling()
      await writeWithTracking()
      
      console.log('='.repeat(60))
      console.log('✅ すべての書き込みが完了しました')
      console.log('='.repeat(60))
    } catch (error) {
      console.error('実行エラー:', error)
      process.exit(1)
    }
  }
  
  // スクリプトとして実行された場合
  if (import.meta.url === `file://${process.argv[1]}`) {
    main()
  }
  
  // 他のファイルからインポートできるようにエクスポート
  export {
    writeBasic,
    writeWithSimulation,
    writeMultiple,
    writeWithGasEstimate,
    writeWithErrorHandling,
    writeWithTracking
  }