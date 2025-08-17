// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//今まで学習したサマリーとして、Blockchain Messengerを作りました。
//Blockchain Messengerとは、ブロックチェーン上にメッセージを保存することができるアプリです。
//また、何度メッセージを更新したかの回数をカウントします。
contract TheBlockchainMessenger{

    uint public changeCounter;

    address public owner;

    string public theMessage;

    constructor(){
        owner = msg.sender;
    }

    function updateTheMessage(string memory _newMessage) public {
        if(msg.sender == owner){
            theMessage = _newMessage;
            changeCounter++;
        }
    }
}