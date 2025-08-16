// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleStrings{

    string public myString ="Hello World";

    // string _myStringとすると、TypeError: Data location must be "memory" or "calldata" for parameter in function, but none was given.というエラーが出る。
    //stringの後ろにmemory or calldataと入れる必要がある。
    //string型は動的サイズのデータ型で、コンパイル時にサイズが決まらないため、データの場所を明示する必要があります。
    //memoryは、関数実行中に一時的にデータを格納する場所で、読み書き可能、関数終了時にデータは消去される。
    //一方、calldataは、関数呼び出し時に渡されるデータの場所で、読み取り専用、Transaction完了時にデータは消去される。
    //トランザクション受信(calldata作成)⇒関数実行開始(memory作成)⇒関数実行⇒関数実行終了(memory消去)⇒トランザクション完了(calldata消去)となる。
    //memoryに比べ、calldataの方がガスコストが安い。
    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    //myString == _myString;とすると、TypeError: Built-in binary operator == cannot be applied to types string storage ref and string memory.というエラーが出る。
    //keccak256とabi.を入れてハッシュを比較ようにすると同じであるかどうかを確認できる。
    //mystringはブロックチェーン上のストレージ上のデータであり、_myStringはメモリ上の文字データであり、物理的に異なる場所に保存されているので比較できない。
    //ABIとはApplication Binary Interfaceで、スマートコントラクトと外部（フロントエンド、他のコントラクト）との通信規約。データのエンコード（符号化）とデコード（復号化）を行う。
    //abi.encodePacked()により、データのバイト配列を作成する。
    //keccak256()により、バイト配列のハッシュ値を計算する。
    //abi.encodePacked(myString)はメモリ上の特定の場所に保存されたバイト配列なので、abi.encodePacked(myString) == abi.encodePacked(_myString)としてしまうと、バイト配列の内容ではなく、メモリ上の特定の場所のアドレスを比較してしまうことになる。
    function compareTwoStrings(string memory _myString) public view returns(bool){
        return keccak256 (abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

}