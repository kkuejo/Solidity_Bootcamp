import { useState, useEffect } from 'react'
import { useAccount, useConnect, useWatchContractEvent, useWriteContract, useWaitForTransactionReceipt, useReadContract } from 'wagmi'
import { formatEther } from 'viem'
import ItemManagerABI from '../contracts/ItemManager.json'
import ItemABI from '../contracts/Item.json'

// デプロイしたコントラクトアドレスを環境変数から取得
const ITEM_MANAGER_ADDRESS = import.meta.env.VITE_ITEM_MANAGER_ADDRESS as `0x${string}`

// 各アイテムの情報を表示するコンポーネント
function ItemCard({ index }: { index: number }) {
  const { data: itemData } = useReadContract({
    address: ITEM_MANAGER_ADDRESS,
    abi: ItemManagerABI.abi,
    functionName: 'items',
    args: [BigInt(index)],
  }) as { data: [string, number, string] | undefined }

  const itemAddress = itemData?.[0] as `0x${string}` | undefined
  const step = itemData?.[1]
  const identifier = itemData?.[2]

  const { data: priceInWei } = useReadContract({
    address: itemAddress,
    abi: ItemABI as any,
    functionName: 'priceInWei',
  }) as { data: bigint | undefined }

  const statusNames = ['Created', 'Paid', 'Delivered']

  if (!itemData) return <div>Loading item {index}...</div>

  return (
    <div style={{
      border: '1px solid #ccc',
      padding: '15px',
      margin: '10px 0',
      borderRadius: '8px',
      backgroundColor: step === 1 ? '#e8f5e9' : step === 2 ? '#e3f2fd' : '#fff'
    }}>
      <h3>Item #{index}: {identifier}</h3>
      <p><strong>Contract Address:</strong> {itemAddress}</p>
      <p><strong>Price:</strong> {priceInWei ? `${priceInWei.toString()} Wei (${formatEther(priceInWei)} ETH)` : 'Loading...'}</p>
      <p><strong>Status:</strong> <span style={{
        fontWeight: 'bold',
        color: step === 1 ? '#2e7d32' : step === 2 ? '#1565c0' : '#666'
      }}>{step !== undefined ? statusNames[step] : 'Unknown'}</span></p>
    </div>
  )
}

// アイテムリストコンポーネント
function ItemList({ itemCount }: { itemCount: number }) {
  return (
    <div>
      {Array.from({ length: itemCount }, (_, i) => (
        <ItemCard key={i} index={i} />
      ))}
    </div>
  )
}

export default function SupplyChain() {
  const { address, isConnected } = useAccount()
  const { connect, connectors } = useConnect()
  const { writeContract, data: hash } = useWriteContract()
  const { isLoading: isConfirming, isSuccess: isConfirmed } = 
    useWaitForTransactionReceipt({ hash })

  const [itemName, setItemName] = useState('exampleItem1')
  const [cost, setCost] = useState('100')
  const [paymentAlert, setPaymentAlert] = useState('')

  // アイテム総数を取得
  const { data: itemIndex, refetch: refetchItemIndex } = useReadContract({
    address: ITEM_MANAGER_ADDRESS,
    abi: ItemManagerABI.abi,
    functionName: 'itemIndex',
  }) as { data: bigint | undefined, refetch: () => void }

  // イベント監視
  useWatchContractEvent({
    address: ITEM_MANAGER_ADDRESS,
    abi: ItemManagerABI.abi,
    eventName: 'SupplyChainStep',
    onLogs(logs) {
      logs.forEach((log: any) => {
        if (log.args.step === 1n) { // Paid
          setPaymentAlert(`Item at ${log.args.itemAddress} was paid! Deliver it now!`)
        }
      })
    },
  })

  const handleCreateItem = async () => {
    try {
      writeContract({
        address: ITEM_MANAGER_ADDRESS,
        abi: ItemManagerABI.abi,
        functionName: 'createItem',
        args: [itemName, BigInt(cost)],
      })
    } catch (error) {
      console.error('Error creating item:', error)
      alert(`Error: ${error}`)
    }
  }

  useEffect(() => {
    if (isConfirmed) {
      alert('Item created successfully!')
      refetchItemIndex() // アイテム一覧を更新
    }
  }, [isConfirmed, refetchItemIndex])

  if (!isConnected) {
    return (
      <div>
        <h2>Connect Your Wallet</h2>
        {connectors.map((connector) => (
          <button
            key={connector.id}
            onClick={() => connect({ connector })}
          >
            Connect with {connector.name}
          </button>
        ))}
      </div>
    )
  }

  return (
    <div>
      <h1>Supply Chain Manager</h1>
      <p>Connected: {address}</p>

      {paymentAlert && (
        <div style={{ background: 'lightgreen', padding: '10px', margin: '10px 0' }}>
          {paymentAlert}
        </div>
      )}

      <h2>Item List</h2>
      {itemIndex !== undefined && Number(itemIndex) > 0 ? (
        <div>
          <p>Total items: {Number(itemIndex)}</p>
          <ItemList itemCount={Number(itemIndex)} />
        </div>
      ) : (
        <p>No items created yet.</p>
      )}

      <h2>Add Element</h2>
      <div>
        <label>
          Cost (in Wei):
          <input
            type="text"
            value={cost}
            onChange={(e) => setCost(e.target.value)}
          />
        </label>
      </div>
      <div>
        <label>
          Item Name:
          <input
            type="text"
            value={itemName}
            onChange={(e) => setItemName(e.target.value)}
          />
        </label>
      </div>
      <button 
        onClick={handleCreateItem}
        disabled={isConfirming}
      >
        {isConfirming ? 'Creating...' : 'Create new Item'}
      </button>
    </div>
  )
}