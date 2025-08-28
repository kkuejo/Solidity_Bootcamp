// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;


contract SendWithdrawMoney{

    uint public balanceReceived;
    function deposit() public payable{
        balanceReceived += msg.value;
    }

    //view functionは、ブロックチェーンの状態を読み取ることができる。
    //スコープ外の変数にアクセスできるが、書き込みができず、読み取り専用。
    function getContractBalance() public view returns(uint){
        //thisは現在のSendWithdrawMoneyコントラクトのインスタンスを指す。
        //address(this)は、そのコントラクトのアドレス（20バイトのイーサリアムアドレス）
        //balanceは、そのアドレスの残高を返す。
        return address(this).balance;
    }

    function withdrawAll() public{
        //address payableは、イーサリアムアドレスを扱うための型。
        //msg.senderはaddress型なので、ETHを受け取ることができないため、payable(msg.sender)を用いてmsg.senderをpayable(address)型にキャストする。
        //toはaddress payable型なので、ETHを受け取ることができる。
        address payable to = payable(msg.sender);
        //transfer()は、ETHを送金するためのSolidityの組み込み関数で、単位はwei。
        //transfer関数は、トランザクションが無限に実行されることを防ぎ、ネットワークの安全性を保ち、悪意のあるコードによる攻撃を防ぐため、2300ガスの制限がある。
        to.transfer(getContractBalance());
    }

    function withdrawToAddress(address payable to) public {
        to.transfer(getContractBalance());
    }

}