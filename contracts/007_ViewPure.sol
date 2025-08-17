// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleViewPure{
    //Solidityには、Writing function, View function, Pure functionの3種類がある。
    //View function, Pure functionともに、多少ガスを使うが、ほぼガス代がかからない。・
    uint public myStorageVariable;

    //View functionはStorage変数にアクセスでき、スコープ外の変数にアクセスできるが、書き込みができない。
    //ブロックチェーンに書き込まれた状態変数は読み取りのみ可能。
    //状態変数や他のコントラクトの状態を参照することができる。
    //外部呼出し(コントラクト間の通信)はガスコストなし、内部呼び出し(同じコントラクト内の関数を呼び出すこと、外部のコントラクトとは通信しない。)はガスコストがかかる。
    //ガスコストは中程度で、状態読み取りが必要な場合に用いる。
    function getMyStorageVariable() public view returns(uint) {
        return myStorageVariable;
    }

    //Pure functionはStorage変数など、スコープ外の変数にアクセスできない。
    //つまり、下の例では、変数a, bにアクセスできるが、関数の外の変数にはアクセスできない。
    //状態変数は読み取らないし、状態変数は更新しない。
    //外部呼出し(コントラクト間の通信)はガスコストなし、内部呼び出し(同じコントラクト内の関数を呼び出すこと、外部のコントラクトとは通信しない。)はガスコストがかかる。この点では、View functionと同じ。
    //ガスコストは低く、状態変数に依存しない場合に用いる。
    function getAddition(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    //Writing functionはブロックチェーンに書き込みができる。(状態変数を変更できる)。
    //ブロックチェーンへの書き込みに伴いガスことが発生。
    //ガスコストは高く、状態変数を更新する場合に用いる。  
    function setMyStorageVariable(uint _newVar) public returns(uint){
        myStorageVariable = _newVar;
        return _newVar; 
    }

}