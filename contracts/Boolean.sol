// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Boolean{
    // Booleanの初期値は0 ;
    bool public myBool;

    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }

}