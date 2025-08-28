// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

contract SampleContract{
    string public myString = "Hello World";

    //payable modifierを利用する。
    //payable modifierは関数がethを受け取ることを期待していることをsolidityに伝えます。 
    function updateString(string memory _newString) public payable {
        //1イーサが送信された場合にのみ、文字列が更新される。
        if(msg.value == 1 ether) {
            myString = _newString;
        } else {
        //msg-objectはスマートコントラクトの現在のメッセージに関する情報が含まれています。
        //msg.senderは現在の呼び出し元のアドレスを返します。
        //transfer関数は指定されたアドレスに指定された量のetherを送信します。
        //msg.senderはaddress型なので、ETHを受け取ることができないため、payable(msg.sender)を用いてmsg.senderをpayable(address)型にキャストします。
            payable(msg.sender).transfer(msg.value) ;
        }
    }
}