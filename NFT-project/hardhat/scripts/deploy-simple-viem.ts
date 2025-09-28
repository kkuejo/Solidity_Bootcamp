import { network } from "hardhat";

async function main() {
  const { viem } = await network.connect({ network: "hardhatMainnet" });
  const counter = await viem.deployContract("Counter");
  console.log(`Counter deployed to: ${counter.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});