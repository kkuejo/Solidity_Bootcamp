// src/read-contract.ts
import { 
    createPublicClient, 
    http,
    parseAbi,
    formatUnits
  } from 'viem'
  import { foundry } from 'viem/chains'
  import type { Address } from 'viem'
  
  // ===== 設定 =====
  
  // コントラクトアドレス（デプロイ後に更新してください）
  const CONTRACT_ADDRESS: Address = '0xa85233c63b9ee964add6f2cffe00fd84eb32338f'
  
  // コントラクトのABI
  const CONTRACT_ABI = parseAbi([
    'function myUint() public view returns (uint256)',
    'function setUint(uint256 _myUint) public'
  ])
  
  // Public Client（読み取り専用）
  const publicClient = createPublicClient({
    chain: foundry,
    transport: http('http://127.0.0.1:8545')
  })
  
  // ===== 読み取り関数 =====
  
  /**
   * 方法1: readContract を使った基本的な読み取り
   */
  async function readBasic() {
    console.log('--- 方法1: 基本的な読み取り ---')
    
    try {
      const value = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      
      console.log('myUint の値:', value.toString())
      console.log('型:', typeof value) // bigint
      console.log()
      
      return value
    } catch (error) {
      console.error('読み取りエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法2: 低レベルAPI（eth_call）を使った読み取り
   */
  async function readLowLevel() {
    console.log('--- 方法2: 低レベルAPI ---')
    
    try {
      // myUint()のfunction selector: 0x06540f7e
      const data = await publicClient.call({
        to: CONTRACT_ADDRESS,
        data: '0x06540f7e'
      })
      
      console.log('生データ:', data.data)
      
      // 16進数をBigIntに変換
      if (data.data) {
        const value = BigInt(data.data)
        console.log('デコード後:', value.toString())
      }
      console.log()
      
      return data
    } catch (error) {
      console.error('低レベル読み取りエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法3: 複数の値を連続で読み取る
   */
  async function readMultiple() {
    console.log('--- 方法3: 複数回読み取り ---')
    
    try {
      // 5回連続で読み取り
      const values: bigint[] = []
      
      for (let i = 0; i < 5; i++) {
        const value = await publicClient.readContract({
          address: CONTRACT_ADDRESS,
          abi: CONTRACT_ABI,
          functionName: 'myUint'
        })
        
        values.push(value)
        console.log(`読み取り ${i + 1}: ${value}`)
        
        // 少し待機（オプション）
        await new Promise(resolve => setTimeout(resolve, 100))
      }
      
      console.log('すべての値:', values.map(v => v.toString()))
      console.log()
      
      return values
    } catch (error) {
      console.error('複数読み取りエラー:', error)
      throw error
    }
  }
  
  /**
   * 方法4: 定期的に値を監視（ポーリング）
   */
  async function monitorValue(intervalMs: number = 5000, maxIterations: number = 3) {
    console.log(`--- 方法4: ${intervalMs}ms ごとに監視 (${maxIterations}回) ---`)
    
    let previousValue: bigint | null = null
    let iteration = 0
    
    const intervalId = setInterval(async () => {
      try {
        const currentValue = await publicClient.readContract({
          address: CONTRACT_ADDRESS,
          abi: CONTRACT_ABI,
          functionName: 'myUint'
        })
        
        const timestamp = new Date().toLocaleTimeString()
        console.log(`[${timestamp}] 現在の値: ${currentValue}`)
        
        // 値が変わったか確認
        if (previousValue !== null && currentValue !== previousValue) {
          console.log(`  ⚠️  値が変更されました: ${previousValue} → ${currentValue}`)
        }
        
        previousValue = currentValue
        iteration++
        
        // 最大回数に達したら停止
        if (iteration >= maxIterations) {
          console.log('監視を終了します\n')
          clearInterval(intervalId)
        }
      } catch (error) {
        console.error('監視エラー:', error)
        clearInterval(intervalId)
      }
    }, intervalMs)
  }
  
  /**
   * 方法5: ブロック番号と一緒に取得
   */
  async function readWithBlockInfo() {
    console.log('--- 方法5: ブロック情報付き読み取り ---')
    
    try {
      // 現在のブロック番号を取得
      const blockNumber = await publicClient.getBlockNumber()
      console.log('現在のブロック番号:', blockNumber)
      
      // 値を読み取り
      const value = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      
      console.log(`ブロック ${blockNumber} 時点の値: ${value}`)
      
      // ブロックの詳細情報
      const block = await publicClient.getBlock({ blockNumber })
      console.log('ブロックタイムスタンプ:', new Date(Number(block.timestamp) * 1000).toLocaleString())
      console.log()
      
      return { value, blockNumber, block }
    } catch (error) {
      console.error('ブロック情報取得エラー:', error)
      throw error
    }
  }
  
  /**
   * 方法6: エラーハンドリング付き
   */
  async function readWithErrorHandling() {
    console.log('--- 方法6: エラーハンドリング ---')
    
    try {
      const value = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      
      console.log('✅ 読み取り成功:', value.toString())
      console.log()
      
      return { success: true, value }
    } catch (error: any) {
      console.error('❌ 読み取り失敗')
      
      if (error.message.includes('could not detect network')) {
        console.error('  原因: Anvilが起動していません')
        console.error('  解決: 別のターミナルで `anvil` を実行してください')
      } else if (error.message.includes('contract')) {
        console.error('  原因: コントラクトアドレスが正しくありません')
        console.error('  解決: CONTRACT_ADDRESS を正しいアドレスに更新してください')
      } else {
        console.error('  エラー詳細:', error.message)
      }
      console.log()
      
      return { success: false, error: error.message }
    }
  }
  
  /**
   * 方法7: 値のフォーマット例
   */
  async function readWithFormatting() {
    console.log('--- 方法7: 値のフォーマット ---')
    
    try {
      const value = await publicClient.readContract({
        address: CONTRACT_ADDRESS,
        abi: CONTRACT_ABI,
        functionName: 'myUint'
      })
      
      console.log('生の値（BigInt）:', value)
      console.log('文字列:', value.toString())
      console.log('数値:', Number(value))
      console.log('16進数:', '0x' + value.toString(16))
      console.log('2進数:', value.toString(2))
      
      // ERC-20の decimals のような場合
      // const formatted = formatUnits(value, 18) // 18 decimals
      // console.log('フォーマット済み:', formatted)
      
      console.log()
      
      return value
    } catch (error) {
      console.error('フォーマットエラー:', error)
      throw error
    }
  }
  
  // ===== メイン実行関数 =====
  
  async function main() {
    console.log('='.repeat(60))
    console.log('📖 スマートコントラクト読み取りサンプル')
    console.log('='.repeat(60))
    console.log()
    
    try {
      // 各読み取り方法を実行
      await readBasic()
      await readLowLevel()
      await readMultiple()
      await readWithBlockInfo()
      await readWithErrorHandling()
      await readWithFormatting()
      
      // 監視（最後に実行）
      await monitorValue(3000, 3)
      
      console.log('='.repeat(60))
      console.log('✅ すべての読み取りが完了しました')
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
    readBasic,
    readLowLevel,
    readMultiple,
    monitorValue,
    readWithBlockInfo,
    readWithErrorHandling,
    readWithFormatting
  }