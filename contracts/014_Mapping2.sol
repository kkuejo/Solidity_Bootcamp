// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

contract ExampleMappingWithdrawals{

    mapping(address => uint) public balanceReceived;

    /*
    以下のように、sendMoney()関数の中身が空だったとしても、payableがあるので、このコントラクトがお金を受け入れる体制は整えられている。
    function sendMoney() public payable {
    }
    */

    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    /*
    このように、先に残高を送金してしまうと、残高がゼロになる前に、再び送金をしてしまう可能性があり、危険である。
    function withdrawAllMoney(address payable _to) public{
        _to.transfer(balanceReceived[msg.sender]);
        balanceReceived[msg.sender] = 0 ;
    }
    */
    //残高をまずゼロにしてから、実際の送金をするべき。
    function withdrawAllMoney(address payable _to) public{
        uint balanceToSentOut=balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0 ;
        _to.transfer(balanceToSentOut);
    }

}