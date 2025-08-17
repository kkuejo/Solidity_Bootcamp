// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleConstructor{ 

    address public myAddress;
    //デプロイした自分のアドレスをmyAddressに割り当てるのであれば以下のような書き方も可能。
    //address public myAddress = msg.sender;


    //constractorはスマートコントラクトのデプロイの再に1度だけ呼び出され、その後に呼び出すことができない特殊な関数
    //あらゆる種類の引数やアドレスを受け入れることができる。
    //一方、publicやprivateなどの指定はしない。
    //デプロイ時に、constructorの引数である_someAddressを指定する必要があるが、デプロイ時の自分以外のアドレスを指定することができる。
    constructor(address _someAddress){
        myAddress = _someAddress;
    }

    function setMyAddress(address _myAddress) public{
        myAddress=_myAddress;
    }

    function setMyAddressToMsgSender() public {
        myAddress = msg.sender;
    }

}