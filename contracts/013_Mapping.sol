// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

contract ExampleMapping{
    //mappingデータ構造はハッシュテーブルのような構造である。
    //ハッシュテーブルは、配列やリストと異なり、インデックスではなく、任意のキーを使用してデータにアクセスできる。
    //ハッシュ関数は、キー⇒ハッシュ関数⇒ハッシュ値(配列のインデックス)とすることができる。
    //例えば、キー: "apple"　⇒ ハッシュ関数　⇒ インデックス3
    //hashtable[3] = "リンゴ"　とデータが格納されているとすると、
    //hashtable["apple"] = "リンゴ"となる。

    //変数名がmyMappingで、キーがuint型、値がstring型のマッピングデータ構造を定義する。
    //myMapping[uint] = stringというハッシュテーブルのような構造を作成する。
    mapping(uint => bool) public myMapping;

    mapping(address => bool) public myAddressMapping;

    //mappingのmappingの例
    mapping(uint => mapping(uint => bool)) public uintUintBoolMapping;

    //setValueは、マッピングの特定のキーに対応する値を設定する関数。
    //setValueで_indexを与えると、それに対する返り値をtrueに設定する。
    //つまり、myMapping[]の引数にすでにsetValue関数を実行した引数を与えると、trueが返ってくるが、
    //それ以外の引数を与えると、falseが返ってくることになる。
    function setValue(uint _index) public{
        myMapping[_index] = true;
    }

    //myAddressToTrue関数を呼び出したことのある、senderのアドレスに対し、myAddressMappingをtrueに設定する。
    function setMyAddressToTrue() public{
        myAddressMapping[msg.sender]=true;
    }
    
    //このネストしたマッピング構造において、
    //第1層: uintUintBoolMapping[_key1] → mapping(uint => bool)型を返す
    //第2層: [uintUintBoolMapping[_key1]][_key2] → bool型の値を返す
    //となっているため、_key1: 1つめのuint（外側のマッピングのキー）、_key2: 2つめのuint（内側のマッピングのキー）、_value: 最終的なbool値に対応している。
    function setUintUintBoolMapping(uint _key1, uint _key2, bool _value) public{
        uintUintBoolMapping[_key1][_key2]= _value;
    }

    //solidityでgetter関数が自動生成されるものは以下のようなもの。
    //publicの変数、配列、マッピング、構造体
    //getter関数とは、オブジェクトやコントラクトの内部データ（状態変数）の値を取得するための関数です。
    //uint public balance;という変数は、public修飾子がついているので、次のようなgetter関数が見えないけれど、バックグラウンドで作成されている。
    /*
    function balance() public view returns(uint) {
        return balance;
    }
     */

    //mapping(uint => bool) public myMapping;は、public修飾子がついているので、次のようなgetter関数が見えないけれど、バックグラウンドで作成されている。
    /*
    function myMapping(uint _key) public view returns(bool) {
        return myMapping[_key];
    }
    */

    //ちなみに、Solidityの設計思想は、外部からのアクセスは関数呼び出しを通じて行い、内部からのアクセスは変数名で直接行うことにより、カプセル化とセキュリティを実現している。
    //上記のbalanceという変数の例で、
    //外部からアクセスする場合は、uint currentBalance = contract.balance();は正しく、uint currentBalance = contract.balanceはエラーとなる。
    //ちなみにcontractは、コントラクトアドレスを表している。
    //コントラクトの内部からアクセスする場合にも、以下のように書く必要がある。
    /*
      contract Example {
        uint public balance;
    
        function internalAccess() public view returns(uint) {
            // 内部では変数名で直接アクセス可能
           return balance;  // 正しい
        }
    
        function externalAccess() public view returns(uint) {
            // 外部からは関数呼び出しが必要
            return this.balance();  // 正しい（thisを使用）
        }
    }  
    */

     }