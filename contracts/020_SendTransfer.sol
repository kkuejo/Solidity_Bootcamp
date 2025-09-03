// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

contract Sender{
    //transferやsendでは、最大2300ガスを消費する。
    //例えば、ガス価格が20gweiの、手数料が2100ガスの時は、42000gweiの手数料を支払うことになる。
    //そして、通常ストレージの書き込みには5000ガス程度必要であるとされている。
    //外部からの送金を受け取るための関数
    receive() external payable{}
    //メソッド(transfer)を利用して10weiを送金
    //ReceiverNoActionにtransferを利用して、10weiを送金する場合は問題は起きない。
    //ReceiverActionにsendを利用して、10weiを送金しようとすると、revertが発生し、トランザクション全体が取り消される。一方、ガス代は消費される。（実際には10weiが送金されておらず、エラーが発生する。）
    //これは、transfer()のガスが2300ガスの制限であるのに対し、ReceiverActionのストレージの書き込みに約5000ガス必要であるからである。
    //ガスはコントラクトではなく、コントラクトの実行者が負担している点に注意が必要。
    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }
    //メソッド(send)を利用して10weiを送金
    //ReceiverNoActionにsendを利用して、10weiを送金する場合は問題は起きない。
    //ReceiverActionにsendを利用して、10weiを送金しようとすると、transfer()と同様、ガスが2300ガスの制限であるため、ReceiverActionのストレージの書き込みに必要なガスが足らず、送金が失敗する。
    //一方、send()は失敗しても、例外を投げず、falseを返すだけであるので、エラーは生じない。
    //そのため、送金が成功したかどうかを確認するためには、boolで結果を受け取り、require()を用いて例外処理を行う必要がある。
    function withdrawSend(address payable _to) public {
        //_to.send(10);
        bool isSent = _to.send(10);
        require(isSent, "Sending the funds was unsuccessful");
    }
}

contract ReceiverNoAction {
    function balance() public view returns(uint){
        return address(this).balance;
    }

    receive() external payable{}
}

contract ReceiverAction {
    uint public balanceReceived;

    receive() external payable{
        balanceReceived += msg.value;
    }

    function balance() public view returns(uint){
        return address(this).balance;
    }
}

//以上より、transferとsendは以下のような使い分けをかんがえることができる。
//transfer(): シンプルで安全、失敗時は自動的に処理が停止(安全な仕様)
//send(): より細かい制御が必要な場合、失敗時の処理をカスタマイズしたい場合(あとで手動でチェックする。)