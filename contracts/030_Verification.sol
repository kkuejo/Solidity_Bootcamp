//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.30;
 
 /*スマートコントラクトをEtherScanで検証する。
    1. Sepoliaテストネットにデプロイする。 
    2. https://sepolia.etherscan.io/tx/0x9db1b7e74ca36c59b50fd9bdc4c5c51b7de3f402d1b4631e87e65295d92c601b
        にデプロイを確認。
    3. https://sepolia.etherscan.io/address/0x3b42ebe61aa7c4daf9fe347d4950ea1da5c01d3a#code
        に本コントラクトのバイトコードがあることを確認。
    4. 3のURLからVerifyを押す。
    5. 必要な情報をインプットし、元のコードをペーストし、承認する。
    6. https://sepolia.etherscan.io/address/0x3b42ebe61aa7c4daf9fe347d4950ea1da5c01d3a#code
       にコントラクトのソースコードが公開される。
 */

contract MyContract {
    mapping(address => uint) public balance;
 
    constructor() {
        balance[msg.sender] = 100;
    }
 
    function transfer(address to, uint amount) public {
        balance[msg.sender] -= amount;
        balance[to] += amount;
    }
 
    function someCrypticFunctionName(address _addr) public view returns(uint) {
        return balance[_addr];
    }
}