// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

contract ContractOne{

    mapping(address => uint) public addressBalances; 

    function deposit() public payable{
        addressBalances[msg.sender] += msg.value;
    }    
    /*
    //receive関数は、Solidityの組み込み関数であり、コントラクトがETHを受け取ると自動的に呼び出される。
    //下記のようにreceive関数を用いると、コントラクトインスタンスでの外部関数呼び出しの例と同じように、deposit()関数を呼び出すことができる。
    //deposit関数だけでなく、transferやsendでETHを受け取った場合にも、deposit()関数を呼び出すことができ、addressBalancesでストレージの書き込みを忘れずに行うことができる。
    //receive関数を定義していないと、transferやsendでETHを受け取った場合に、別途deposit関数を呼び出し、addressBalancesでストレージの書き込みを行う必要がある。
    receive() external payable{
        deposit();
    }
    */
}

//送金する際に、より多くのガスを送金する方法として、以下の2通りがある。
//1. コントラクトインスタンスでの外部関数呼び出し
//2. アドレスに対する低レベルの呼び出し
contract ContractTwo{
    receive() external payable {}

    function depositOnContractOne(address _contractOne) public {
        /* 1のコントラクトインスタンスでの外部関数呼び出しの例。
        oneでcontractOneを呼び出し、そのdeposit()関数を呼び出している。
        その際に、value:10weiを支払い、100000のガスを指定して実行している。
        ちなみに、100000のガスがすべて使用されたわけではなく、残りは変換されていることに注意。
        これにより、addressBalancesでストレージの書き込みを行うにも関わらず、十分なガス量を送っているのでエラーが出ていない。
        ContractOne one = ContractOne(_contractOne);
        one.deposit{value: 10, gas: 100000}();
        */

        //2. アドレスに対する低レベルの呼び出しの例。
        //abi(Application Binary Interface)を利用し、"deposit()" を"0xd0e30db0"というバイトコードに変換している。
        //With Signitureは関数シグネチャという意味で、関数名とパラメータの型の定義の両方を含む意味である。
        bytes memory payload = abi.encodeWithSignature("deposit()");
        //低レベルcallを利用し、_contractOneに対して、value:10weiを支払い、100000のガスを指定して実行している。
        //callデータの返り値は、(bool success, bytes memory data)であるが、dataは使用していないので、情報を受け取っていない。
        //低レベルcallは失敗しても、falseを返すだけであるので、エラーは生じないので、成功したかどうかを確認するために、require()を用いて例外処理を行う必要がある。
        (bool success, ) = _contractOne.call{value: 10, gas: 100000}(payload);
        require(success);
    }
}