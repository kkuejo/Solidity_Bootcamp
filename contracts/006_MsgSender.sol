// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleMsgSender{

    address public someAddress;

    //最後にこのコントラクトを呼び出している人のアドレスが表示される。
    //Accountから本コントラクトを直接呼び出した場合は、msg.senderはAccountになる。
    //一方、Accountから他のコントラクトが呼び出され、そのコントラクトが本コントラクトを呼び出した場合には、呼び出しを行ったコントラクトのアドレスが、msg.senderとなる。
    function updateSomeAddress() public {
        someAddress = msg.sender;

    }
}