// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

//contractは大文字から始める。
//WalletをChild Smart Contractを用いて書いた例
//Child Smart Contractを用いる場合は、ガス代が高いことと、別のコントラクトとやり取りせずに、直接getter関数にアクセスできない。
//Child Smart Contractのメリットは、以下の通り。
//1. 独立性: PaymentReceivedコントラクトは独立したコントラクトとして存在するため、別のコントラクトとは分離されている。
//2. 再利用性: 他のコントラクトでも使用可能
//3. 拡張性: 将来的に機能を追加しやすい
//4. 分離: 支払い処理のロジックを完全に分離
contract Wallet{
    PaymentReceived public payment;

    function payContract() public payable{
        //newは、新しいコントラクトインスタンスを動的に作成するためのキーワード
        payment = new PaymentReceived(msg.sender, msg.value) ;
    }
}

contract PaymentReceived{
    address public from;
    uint public amount;

    constructor(address _from, uint _amount){
        from = _from;
        amount = _amount;
    }
}

//Walletを構造体を用いて書いた例
//ガス代が安いことと、別のコントラクトとやり取りせずに、直接getter関数にアクセスできる。
//Structを用いる場合のメリットは以下の通り。
//1. ガス代が安い: 新しいコントラクトを作成しないため
//2. 直接アクセス: payment.fromやpayment.amountで直接アクセス可能
//3. シンプル: 1つのコントラクト内で完結
//4. 高速: 外部コントラクト呼び出しがない
contract Wallet2 {
    
    struct PaymentReceivedStruct {
        address from;
        uint amount;
    }

    PaymentReceivedStruct public payment;

    function payContract() public payable {
        //payment = PaymentReceivedStruct(msg.sender, msg.value);
        payment.from = msg.sender;
        payment.amount = msg.value;
    }
}