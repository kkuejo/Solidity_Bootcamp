// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

contract MappingStructExample{

    struct Transaction{
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public balances;

    function getDepositNum(address _from, uint _numDeposit) public view returns(Transaction memory){
        //numDepositは、depositsのインデックスである。(つまり、入金履歴の番号)。
        return balances[_from].deposits[_numDeposit];
    }

    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;
        //depositは関数実行中のみに存在すれば十分なので、Storage変数ではなく、Memory変数として宣言する。
        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        //入金のTransactionをdepositsに追加する。
        //最初のアドレスXのTransaction(金額、タイムスタンプ)をbalances[X].deposits[0]に格納する。
        //2回目のTransaction(金額、タイムスタンプ)をbalances[X].deposits[1]に格納する。   
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
        balances[msg.sender].numDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        balances[msg.sender].totalBalance -= _amount;
        Transaction memory withdrawal = Transaction(_amount, block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal; 
        balances[msg.sender].numWithdrawals++;
        _to.transfer(_amount);
    }
}