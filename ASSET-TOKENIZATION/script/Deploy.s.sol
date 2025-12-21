// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
// import {MyTokenSale} from "../src/MyTokenSale.sol";
// import {KycContract} from "../src/KycContract.sol";

contract DeployScript is Script {
    function run() public {
        // 環境変数から初期トークン量を取得（デフォルト: 1,000,000）
        uint256 initialTokens = vm.envOr("INITIAL_TOKENS", uint256(1000000));

        // デプロイヤーの秘密鍵を環境変数から取得
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== Deployment Started ===");
        console.log("Deployer address:", deployer);
        console.log("Initial token supply:", initialTokens);

        vm.startBroadcast(deployerPrivateKey);

        // MyTokenをデプロイ
        // recipient: トークンを受け取るアドレス（デプロイヤー）
        // initialOwner: コントラクトのオーナー（デプロイヤー）
        // initialSupply: 初期供給量
        MyToken token = new MyToken(deployer, deployer, initialTokens);

        console.log("\n=== MyToken Deployed ===");
        console.log("Contract address:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Decimals:", token.decimals());
        console.log("Total supply:", token.totalSupply());
        console.log("Owner:", token.owner());
        console.log("Recipient balance:", token.balanceOf(deployer));

        // 将来の拡張用: 他のコントラクトのデプロイ
        // KycContract kycContract = new KycContract();
        // console.log("KycContract deployed at:", address(kycContract));

        // MyTokenSale tokenSale = new MyTokenSale(
        //     1,  // rate
        //     deployer,  // wallet address
        //     address(token),
        //     address(kycContract)
        // );
        // console.log("MyTokenSale deployed at:", address(tokenSale));

        // トークンをTokenSaleコントラクトへ転送
        // token.transfer(address(tokenSale), initialTokens);
        // console.log("Transferred", initialTokens, "tokens to TokenSale contract");

        vm.stopBroadcast();

        // デプロイ情報のまとめ
        console.log("\n=== Deployment Summary ===");
        console.log("MyToken:", address(token));
        // console.log("KycContract:", address(kycContract));
        // console.log("MyTokenSale:", address(tokenSale));
        console.log("========================");
    }
}
