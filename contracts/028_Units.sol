// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract SampleUnits{
    modifier betweenOneAndTwoEth(){
        //10000000000000000が1ETHであるが、このように書くと間違える可能性がある。
        //require(msg.value >= 1000000000000000000 && msg.value <= 2000000000000000000);
 
        //1e18という書き方でも良く、これは、1×10の18乗を表している。
        //require(msg.value >= 1e18 && msg.value <= 2e18);
 
        //1 etherと書いてもよい。
        require(msg.value >= 1 ether && msg.value <= 2 ether);
        _;
        //それ以外にも、ether, gwei, weiを利用することができる。
    }

    uint runUntilTimestamp;
    uint startTimestamp;

    constructor(uint startInDays){
        //トークンセールを7日間行いたいと思っているが、Solidityでは秒で書く必要がある。
        /*
        startTimestamp = block.timestamp + (startInDays * 24 * 60 *60) ;
        runUntilTimestamp = startTimestamp + (7 * 24 * 60 *60) ;
        */
        //daysを利用すると、掛け算を用いて秒に変換する必要がなくなる。
        startTimestamp = block.timestamp + (startInDays * 1 days) ;
        runUntilTimestamp = startTimestamp + (7 days) ;
        //これ以外にも、seconds, minutes, hours, days, weeksが利用できる。yearは365日と限らないので、Solidityでは利用することができない。
    }


}