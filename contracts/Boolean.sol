// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Boolean{
    // Booleanの初期値は0 ;
    bool public myBool;

    function setMyBool(bool _myBool) public {
        myBool = _myBool;
        //_myBoolではない方を代入
        myBool = !_myBool;
        //各種論理演算の結果を代入
        myBool = true && _myBool;
        myBool = true || _myBool;
        myBool = true == _myBool;
        myBool = true != _myBool;
    }

}