// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract EventExample{

    mapping(address => uint) public tokenBalance;
    
    /*Eventの役割は以下の通り。
    1. ログの記録
    ブロックチェーンに永続的に記録されるログデータを作成し、トランザクションの実行履歴として残す。
    2. フロントエンドとの通信
    スマートコントラクトからフロントエンドアプリケーションへの通知手段で、リアルタイムで状態変化を監視できる。
    3. ガス効率の向上
    データをストレージに保存するよりもガスコストが安い。履歴データの保存に最適。
    4. 検索とフィルタリング
    indexedを使用することで、特定の条件に合致するイベントを検索・フィルタリングできる。
    indexedパラメータについては以下の制限がある。
    a.最大3つ
    b.indexedパラメータは32バイトに制限
    c.非indexedパラメータは検索できないが、データの取得は可能
    d. フィルタリングは完全一致のみで、部分一致は不可能
    */
    event TokensSente(address indexed _from, address indexed _to, uint _amount);

    constructor(){
        tokenBalance[msg.sender] = 100;
    }

    function sendToken(address _to, uint _amount) public returns(bool) {
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
        //emitを使用することで、上で定義したeventを発行する。
        emit TokensSente(msg.sender, _to, _amount);
   
        return true;
    }
}