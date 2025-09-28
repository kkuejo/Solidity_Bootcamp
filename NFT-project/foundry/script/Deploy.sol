// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
 
import "forge-std/Script.sol";
import "../src/Spacebear.sol";
 
 //Spacebearコントラクトをデプロイするスクリプト。Script.solを承継している。
contract SpacebearScript is Script {
    //Scriptを継承するためにsetUp()を定義する必要がある 。ただし、事前初期化が必要ない場合は、空のままで良い。
    //複数のコントラクトの順序立てデプロイ、依存関係のある設定などを行う必要がある場合などには、setUp()を使用する。
    function setUp() public {}
    
    //run()は、デプロイを実行するための関数。
    function run() public {
        // 環境変数から秘密鍵を取得
        //forge-stdライブラリの一部で、指定した環境変数を文字列として取得する。
        //uint256 privateKey = $PRIVATE_KEY;  // Solidityでは不可能。
        //source .envはシェルで環境変数を設定し、背hるでは見えるが、forge scriptの実行時は別のプロセスで、Foundryの実行環境からは見えない。
        //source .envで読み込んだ環境変数も、最終的にはvm.envStringを通じて安全かつ確実に取得するのが、Foundryの推奨される方法です。
        string memory privateKeyString = vm.envString("PRIVATE_KEY");
        //vm.parseUint()は、文字列をuint256に変換する。
        uint256 privateKey = vm.parseUint(privateKeyString);
        
        //vm.startBroadcast()は、デプロイを開始する。コントラクトのデプロイ時には必須の関数。
        //これ以降、ブロックチェーンへの送信を開始、秘密鍵を使用してトランザクションに署名、この後の操作をブロックチェーンに送信する、RPCエンドポイントとの通信を確立する。
        vm.startBroadcast(privateKey);
        
        // Spacebearコントラクトをデプロイ
        Spacebear spacebear = new Spacebear(msg.sender);
        
        // デプロイされたコントラクトのアドレスを出力
        console.log("Spacebear deployed at:", address(spacebear));
        
        //コントラクトのデプロイトランザクションの終了。
        vm.stopBroadcast();
    }
}