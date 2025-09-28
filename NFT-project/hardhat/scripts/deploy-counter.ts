import "@nomicfoundation/hardhat-ethers";
import hre from "hardhat";

async function main() {
  console.log("Deploying Counter contract to Sepolia...");

  // デプロイするアカウントの情報を表示
  const [deployer] = await (hre as any).ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  // アカウントの残高を確認
  const balance = await (hre as any).ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", (hre as any).ethers.formatEther(balance), "ETH");

  // コントラクトのデプロイ
  const Counter = await (hre as any).ethers.getContractFactory("Counter");
  const counter = await Counter.deploy();
  
  console.log("Waiting for deployment confirmation...");
  await counter.waitForDeployment();

  const contractAddress = await counter.getAddress();
  console.log("✅ Counter deployed to:", contractAddress);

  // デプロイ後の検証
  console.log("\nVerifying deployment...");
  const initialValue = await counter.x();
  console.log("Initial value of x:", initialValue.toString());

  // ネットワーク情報の表示
  const network = await (hre as any).ethers.provider.getNetwork();
  console.log("Network:", network.name, "Chain ID:", network.chainId);

  // Etherscanでの確認用URL（Sepoliaの場合）
  if (network.chainId === 11155111n) { // Sepolia Chain ID
    console.log("View on Etherscan: https://sepolia.etherscan.io/address/" + contractAddress);
  }

  console.log("Deployment completed successfully!");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});
