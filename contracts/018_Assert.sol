// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

contract ExapmleExceptionRequire{
    
    //uintのレンジが広すぎるので、いったんuint8に小さくして実験。
    //uint8は0から255までの整数を表す。
    mapping(address => uint8) public balanceReceived;

    function receiveMoney() public payable {
        //uint8()を用いて、受取額をuintからuint8に型を変換。
        //つまり、WrapAroundにより、uint8()は、256で割った余りを返す。
        //assert(condition)は、conditionがfalseの場合、transaction全体がrevert(される)。
        //conditionがtrueの場合、transactionは継続される。
        //256wei以上のを入金しようとすると、エラーが出て、トランザクションが失敗する。
        //このassertがないと、256wei以上の入金ができてしまうものの、WrapAroundにより、balanceReceivedの値は、255以下となる。
        //例えば、300weiを入金しようとすると、assertがないと、balanceReceivedの値は、44(=300-256)となり、300weiの送金ができるのに、残高は44weiとなる。
        //assertがあると、エラーが出て、トランザクションが失敗し、このエラーを防ぐことができる。
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
    }

   
    function withdrawMoney(address payable _to, uint8 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough funds, aborting!"); 
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}