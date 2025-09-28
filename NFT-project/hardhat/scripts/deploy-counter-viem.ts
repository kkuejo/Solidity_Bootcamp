import { network } from "hardhat";
import { parseEther } from "viem";

async function main() {
  console.log("Deploying Counter contract using Viem...");

  // ネットワークに接続
  const { viem } = await network.connect({ network: "hardhatMainnet" });

  // ウォレットクライアントを取得
  const [deployer] = await viem.getWalletClients();
  console.log("Deploying with account:", deployer.account.address);

  // パブリッククライアントを取得
  const publicClient = await viem.getPublicClient();

  // アカウントの残高を確認
  const balance = await publicClient.getBalance({
    address: deployer.account.address
  });
  console.log("Account balance:", parseEther(balance.toString()), "ETH");

  // コントラクトのデプロイ
  const counter = await viem.deployContract("Counter");
  console.log("✅ Counter deployed to:", counter.address);

  // デプロイ後の検証
  console.log("\nVerifying deployment...");
  const initialValue = await counter.read.x();
  console.log("Initial value of x:", initialValue.toString());

  // ネットワーク情報の表示
  const chainId = await publicClient.getChainId();
  console.log("Chain ID:", chainId);

  console.log("Deployment completed successfully!");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});