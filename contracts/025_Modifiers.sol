// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract InheritanceModifierExample{

    mapping(address => uint) public tokenBalance;

    address owner;

    uint tokenPrice = 1 ether;

    constructor(){
        owner = msg.sender;
        tokenBalance[owner] = 100;
    }
    
    //function createNewToken, burnTokenの両方に、require(msg.sender == owner, " You are not allowed");があるので、modifier(修飾子)を使って、その部分をまとめることができる
    //modifierの名前はonlyOwnerとする
    //modifierの定義は、modifier onlyOwner(){}の中に、require(msg.sender == owner, " You are not allowed");を書く
    //modifierの呼び出しは、functionの前にonlyOwnerを書く
    //modifierの呼び出しは、function createNewToken() public onlyOwner{}のようになる
    //modifierは、特定の条件を満たした場合のみ、関数を実行することを表す。
    //特定の条件を満たした場合にのみ関数を実行したい場合などに用いることができる。
    modifier onlyOwner(){
        require(msg.sender == owner, " You are not allowed");
        //_;は、modifierが呼び出された関数の本体を表す。
        //例えば、function createNewToken() public onlyOwner{}の場合、_はcreateNewToken()の本体、つまり、tokenBalance[owner]++;を表しており、これを実行する場所を_;で表す。
        _;   
    }
    //関数の前にonlyOwnerを書くことで、function createNewToken() public onlyOwner{}のようになる
    function createNewToken() public onlyOwner{
        //require(msg.sender == owner, " You are not allowed");
        tokenBalance[owner]++;
    }

    function burnToken() public onlyOwner{
        //require(msg.sender == owner, "You are not allowed");
        tokenBalance[owner]--;
    }

    function purchaseToken() public payable{
        require((tokenBalance[owner] * tokenPrice) - msg.value > 0, "Not enough tokens");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }

    function sendToken(address _to, uint _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
    }
    
} 


