// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
// pragma solidity ^0.7.5;

contract ExampleWrapAround{
    uint256 public myUint; 
    uint8 public myUint8 = 2**4; 

    function setMyUint(uint _myUint) public{
        myUint = _myUint;
    } 

    // myUintのデフォルト値が0なので、dedrementUintを実行するとエラーが出る。これはSolidityのバージョン8からである。
    // solidityのバージョン7を用いると, myUint=0に対し、decrementUintを実行するとmyIntの値は2^256-1となる。
    // Solidyのバージョン8でも、uncheckedを導入すると、このInteger Rolloverを実現することができる。
    function decrementUint() public{
        unchecked{
            myUint--;
        }
    }

    function incrementUint8() public{
        myUint8++;
    }

}