// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract StartStopUpdateExample {
    bool public destroyed = false;
    
    modifier notDestroyed() {
        require(!destroyed, "Contract has been destroyed");
        _;
    }
    
    receive() external payable notDestroyed {}

    function destroySmartContract() public {
        /*以前のSolidityでは、selfdestruct(payable(msg.sender));というコードを使って、コントラクトを破壊することができた。
        しかし、Solidity 0.8.30において、Solidityでは、selfdestruct(payable(msg.sender));というコードを使って、残りのEtherを送信者に送信し、コントラクトを破壊することができなくなった。
        代わりに、destroyed = true;というコードを使って、コントラクトを破壊することができる。
        また、残りのEtherを送信者に送信するために、payable(msg.sender).transfer(address(this).balance);というコードを使って、残りのEtherを送信者に送信することができる。        
        selfdestruct(payable(msg.sender));
        */

        destroyed = true;
        // 残りのEtherを送信者に送信
        payable(msg.sender).transfer(address(this).balance);
    }
} 