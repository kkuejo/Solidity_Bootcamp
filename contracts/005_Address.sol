// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleAddress{
    //address型はSolidity特有の型で、Ethereumの20バイトのアドレスを表す。
    //address型のデフォルトはゼロアドレス。つまり、0xの後に40個のゼロ、つまり、20バイトのゼロが続きます。
    address public someAddress;

    function setSomeAddress(address _someAddress) public {
        someAddress = _someAddress;
    }

    //アドレスのバランスを返すこともできる。
    //バランスはWEIという単位で返される。
    //1ETH = 10^18 WEIである。
    //スマートコントラクト内ではETHは使わずに、WEIを利用することが多い。
    function getAddressBalance() public view returns(uint) {
        return someAddress.balance;
    }

}
