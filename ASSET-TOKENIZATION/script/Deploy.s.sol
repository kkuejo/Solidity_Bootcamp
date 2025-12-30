// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
import {MyTokenSale} from "../src/MyTokenSale.sol";
import {KycContract} from "../src/KycContract.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
        // initialSupply: 初期供給量（デプロイヤーに mint される）
        MyToken token = new MyToken(initialTokens);

        console.log("\n=== MyToken Deployed ===");
        console.log("Contract address:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Decimals:", token.decimals());
        console.log("Total supply:", token.totalSupply());
        console.log("Deployer balance:", token.balanceOf(deployer));

        // KycContractをデプロイ
        KycContract kycContract = new KycContract();

        console.log("\n=== KycContract Deployed ===");
        console.log("Contract address:", address(kycContract));
        console.log("Owner:", kycContract.owner());

        // MyTokenSaleをデプロイ
        // rate: 1 wei = 1 token
        // wallet: デプロイヤーのアドレス（ETHを受け取る）
        // token: MyTokenのアドレス
        // kycContract: KycContractのアドレス
        MyTokenSale tokenSale = new MyTokenSale(
            1,  // rate: 1 wei = 1 token
            payable(deployer),  // wallet address
            IERC20(address(token)),
            kycContract
        );

        console.log("\n=== MyTokenSale Deployed ===");
        console.log("Contract address:", address(tokenSale));
        console.log("Rate:", tokenSale.rate());
        console.log("Wallet:", tokenSale.wallet());
        console.log("Token:", address(tokenSale.token()));
        console.log("KYC Contract:", address(tokenSale.kycContract()));

        // トークンをTokenSaleコントラクトへ転送
        token.transfer(address(tokenSale), initialTokens);
        console.log("\n=== Token Transfer ===");
        console.log("Transferred", initialTokens, "tokens to TokenSale contract");
        console.log("TokenSale balance:", token.balanceOf(address(tokenSale)));
        console.log("Deployer balance:", token.balanceOf(deployer));

        vm.stopBroadcast();

        // デプロイ情報のまとめ
        console.log("\n=== Deployment Summary ===");
        console.log("MyToken:", address(token));
        console.log("KycContract:", address(kycContract));
        console.log("MyTokenSale:", address(tokenSale));
        console.log("========================");
    }
}
