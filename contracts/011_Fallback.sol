// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

//スマートコントラクトはデフォルトでは何も受け取ることはできません。

contract SampleFallback{

    uint public lastValueSent;
    string public lastFunctionCalled;

    uint public myUint;

    function setMyUint(uint _myNewUint) public{
        myUint = _myNewUint;
    }


    //receive関数とfallback関数は、コントラクトに送信されたETHを受け取るための特別な関数です。
    //receive関数、fallback関数はconstructor関数のように、Solidity組み込み関数なので、functionキーワードを使用して定義する必要はありません。
    //receive関数は、コントラクトに送信されたETHを受け取るための特別な関数です。
    //ここでは、receive関数は外部からのETH送金を処理するために使用することを想定しているため、内部の呼び出しを不要とし、externalを利用している。
    
    //関数の優先順位は以下の通り。
    //1. 通常の関数が存在する場合 → その関数が実行される
    //2.receive()が定義されている場合 → ETH送金（データなし）で実行
    //3. fallback() → 上記以外のすべてのケースで実行
    //つまり、ETH送金（データなし）→ receive()が呼ばれる
    // ETH送金（データあり）→ fallback()が呼ばれる
    // 存在しない関数呼び出し→ fallback()が呼ばれる

    //ちなみに、外部からの呼び出しは以下のように行われる。
    // 1. 存在しない関数の呼び出し
    //contract.someNonExistentFunction(); // → fallback()が呼ばれる
    // 2. データ付きETH送金
    //contract.send({value: 1 ether, data: "0x1234"}); // → fallback()が呼ばれる
    // 3. 空の関数呼び出し
    //contract.call(""); // → fallback()が呼ばれる

    receive() external payable{
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";  
    }


}