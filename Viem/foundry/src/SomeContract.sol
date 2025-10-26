// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract SomeContract {
    uint256 public myUint = 10;

    function setUint(uint256 _myUint) public {
        myUint = _myUint;
    }
}