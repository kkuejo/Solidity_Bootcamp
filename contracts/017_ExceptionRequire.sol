// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

contract ExapmleExceptionRequire{

    mapping(address => uint) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

     /*
     if文を使ってしまうと、ウォレットに十分なバランスがないと何も起きないだけで、ユーザーからのフィードバックもない。
     つまり、お金を引き出そうとして、残高以上のお金を引き出そうとしても、トランザクションは問題なく機能し、内部的には何も起きていない状態。
    function withdrawMoney(address payable _to, uint _amount) public {
        if(_amount <= balanceReceived[msg.sender]){
            balanceReceived[msg.sender] -= _amount;
            _to.transfer(_amount);
        }
    }
    */
   
    function withdrawMoney(address payable _to, uint _amount) public {
        //requireの中が満たさなければ、コントラクトの全部が実行されない。また、エラーメッセージが出力される。
        //つまり、ifの代わりにrequireを利用すると、トランザクションに失敗するだけでなく、ユーザーに適切なフィードバックが得られることになる。
        require(_amount <= balanceReceived[msg.sender], "Not enough funds, aborting!"); 
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}