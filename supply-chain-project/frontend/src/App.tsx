import { WagmiProvider } from 'wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { config } from './wagmi.config'
import SupplyChain from './components/SupplyChain'

const queryClient = new QueryClient()

function App() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <div className="App">
          <SupplyChain />
        </div>
      </QueryClientProvider>
    </WagmiProvider>
  )
}

export default App