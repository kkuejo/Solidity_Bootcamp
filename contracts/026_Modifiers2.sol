// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

//このファイルにcontract Owner{}を毎回書く必要がある。
//このcontract Owner{}を再利用するために、027_Ownable.solを作成し、これをインポートすることとすればよい。
/*
contract Owner{
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, " You are not allowed");
        _;   
    }

}
*/
//contract Owner{}をインポートする
import "./027_Ownable.sol";

//contract Owner{}を継承するために、is Ownerとする。
//isはコントラクトを継承することを表すキーワードである。
//継承をすると、親クラス(基底クラス)の全機能を子クラス(派生クラス)が受け継ぎ、全機能が利用可能となる。
//ここでは、InheritanceModifierExampleはOwnerを継承しているので、InheritanceModifierExampleはOwnerの全機能が利用可能となる。
//また、子クラス(InheritanceModifierExample)で、新しい機能を追加したり、既存の機能を変更することができる。
contract InheritanceModifierExample is Owner{

    mapping(address => uint) public tokenBalance;

    uint tokenPrice = 1 ether;

    constructor(){
        tokenBalance[msg.sender] = 100;
    }
    
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
