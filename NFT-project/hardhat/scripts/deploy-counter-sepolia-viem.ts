import { network } from "hardhat";
import { formatEther } from "viem";

async function main() {
  console.log("Deploying Counter contract to Sepolia using Viem...");

  // Sepoliaネットワークに接続
  const { viem } = await network.connect({ network: "sepolia" });

  // ウォレットクライアントを取得
  const [deployer] = await viem.getWalletClients();
  console.log("Deploying with account:", deployer.account.address);

  // パブリッククライアントを取得
  const publicClient = await viem.getPublicClient();

  // アカウントの残高を確認
  const balance = await publicClient.getBalance({
    address: deployer.account.address
  });
  console.log("Account balance:", formatEther(balance), "ETH");

  // コントラクトのデプロイ
  console.log("Deploying Counter contract...");
  const counter = await viem.deployContract("Counter");

  console.log("Waiting for deployment confirmation...");
  const address = counter.address;

  console.log("✅ Counter deployed to:", address);

  // デプロイ後の検証
  console.log("\nVerifying deployment...");
  const initialValue = await counter.read.x();
  console.log("Initial value of x:", initialValue.toString());

  // ネットワーク情報の表示
  const chainId = await publicClient.getChainId();
  console.log("Network: Sepolia, Chain ID:", chainId);

  // Etherscanでの確認用URL
  if (chainId === 11155111) { // Sepolia Chain ID
    console.log("View on Etherscan: https://sepolia.etherscan.io/address/" + address);
  }

  console.log("Deployment completed successfully!");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});