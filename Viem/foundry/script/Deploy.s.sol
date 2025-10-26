// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

//Scriptはデプロイに必要
//consoleはデプロイログを出力するために必要(console.log)。
import {Script, console} from "forge-std/Script.sol";
//SomeContract.solをインポート
//デプロイ対象のコントラクト
import {SomeContract} from "../src/SomeContract.sol";

//DeployScriptは、Scriptコントラクトを継承している。
//isは継承を表す。 
contract DeployScript is Script {
    //runはデプロイを実行する関数
    //externalは外部関数を表す。
    //runはEOAで実行されるので、外部が前提。
    //publicだと、外部・内部で実行できるが、ガス効率が悪い。
    function run() external {
        //vmはscriptの継承で起用できる。
        //startBroadcastはデプロイで、トランザクションの収集を開始する。
        vm.startBroadcast();
        //SomeContractをインスタンス化。
        //1. SomeContract（型）: デプロイするコントラクトの定義
        //2. new SomeContract(): ブロックチェーン上に実体を作成
        //3. someContract: 作成されたインスタンスへの参照
        SomeContract someContract = new SomeContract();
        //コントラクトアドレスを出力       
        console.log("Contract deployed at:", address(someContract));
        //stopBroadcastはデプロイで、トランザクションの収集を停止する。
        vm.stopBroadcast();
    }
}

//この後の--broadcastによって、ブロックチェーンに送信する。