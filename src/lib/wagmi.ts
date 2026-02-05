import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { mainnet, sepolia } from 'wagmi/chains';

const chainId = parseInt(process.env.NEXT_PUBLIC_CHAIN_ID || '11155111');
const chains = chainId === 1 ? [mainnet] : [sepolia];

export const config = getDefaultConfig({
  appName: 'Ultra-Simple Commerce',
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID!,
  chains: chains as any,
  ssr: true,
});
