// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleUint{
    //デフォルトはゼロ
    uint public myUint; //uintはuint256のエイリアス
    uint public myUint2 = 200;
    uint256 public myUint256; // 0 - (2^256) -1
    uint8 public myUint8 = 250; // 0 - (2^8) -1 = 0 - 255。ガスコストを節約するには小さいものを選ぶこと
    int public myint = -10 ; // -2^255 to + 2^255 -1 (intはint256のエイリアス)
    int256 public myint256; // -2^255 to +2^255 -1

    function setMyUint(uint _myUint) public{
        myUint = _myUint;
    } 

    function decrementUint8() public{
        myUint8--;
    }

    function incrementUint8() public{
        myUint8++;
    }

}