// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

//このコントラクトは常にエラーを発生させる。
contract WillThrow{
    //errorにより、カスタムエラー型を宣言する。
    //NotAllowedErrorは、stringを引数に取るカスタムエラー型である。
    error NotAllowedError(string);
    function aFunction() public pure{
        //require(false)により、常にError(string)が発生する。
        require(false, "Error message");
        //assert(false);により、常にpanic errorが発生する。
        //assert(false);
        //revert NotAllowedError("You are not allowed");
    }
}

//以下では、エラーをcatchするためのコードを記述する。
//Try-Catchでエラーを補足するポイントは以下の通り。
//1.エラーを無視するのではなく、適切に処理する
//2.ユーザーに分かりやすいフィードバックを提供
//3.アプリケーションの堅牢性を向上させる
//4.開発・運用時の問題追跡を容易にする
contract ErrorHandling{
    //eventにより、エラー情報をブロックチェーン上にログに記録する。
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);
    function catchTheError() public {
        WillThrow will = new WillThrow();

        //tryにより、エラーが発生する可能性のある関数を実行する。
        //成功時は、このブロック内のコードが実行される。
        //失敗時には、catchブロックに処理が移る。
        try will.aFunction(){
            //add code here if it works
        } catch Error(string memory reason){
            //requireやrevertで発生するError(string)のエラーをcatchする。
            emit ErrorLogging(reason);
        } catch Panic(uint errorCode){
            //assertで発生するPanic errorをcatchする。
            emit ErrorLogCode(errorCode);
        } catch (bytes memory lowLevelData){
            //lowLevelDataにとは、低レベルエラーやカスタムエラーをcatchする。
            //低レベルエラーとは、Solidityの高レベルなエラーハンドリング(requireやrevert,assert,panic)ではキャッチできないエラーをcatchする。
            emit ErrorLogBytes(lowLevelData);
        }

    }
}