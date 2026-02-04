# Adding Wallet Interactions

**Type:** Template

**When to use:** When adding contract calls or wallet signing

## Principles

- Use wagmi hooks, don't call ethers/viem directly
- Handle all connection states (connecting, disconnected, wrong network)
- Always show transaction status to user
- Use environment variables for contract addresses

## Template: Contract Write

```tsx
import { useContractWrite, useWaitForTransaction } from 'wagmi'
import { parseUnits } from 'viem'

const USDC_ADDRESS = process.env.NEXT_PUBLIC_USDC_ADDRESS

export function usePayment() {
  const { write, data, isLoading: isWriteLoading, error: writeError } = useContractWrite({
    address: USDC_ADDRESS,
    abi: USDC_ABI,
    functionName: 'transferWithAuthorization',
  })

  const { isLoading: isTxLoading, isSuccess, error: txError } = useWaitForTransaction({
    hash: data?.hash,
  })

  return {
    pay: write,
    isLoading: isWriteLoading || isTxLoading,
    isSuccess,
    error: writeError || txError,
    txHash: data?.hash,
  }
}
```

## Checklist

- [ ] Handles wallet not connected state
- [ ] Handles wrong network state
- [ ] Shows pending transaction state
- [ ] Shows success/error result
- [ ] Uses environment variables for contract addresses
- [ ] Exposes transaction hash for verification
