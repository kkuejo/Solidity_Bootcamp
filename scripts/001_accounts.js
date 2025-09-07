//async functionは非同期関数を定義するためのキーワード
//同期処理では、1つずつ順番に処理を実行し、ブロッキングであるため前の処理が完了するまで次の処理を待つ。
//ただし、ブロックチェーンはブロックチェーンノードとの通信や、ブロックに含まれるまで待機が必要である為、非同期処理で実行する。
//処理の完了を待つ必要があるときはawaitを用いる。
(async() => {
    //console.log()はコンソールに出力するJavaScriptの命令
    //console.log("abc") ;
    let accounts = await web3.eth.getAccounts();
    console.log(accounts, accounts.length);
    let balance = await web3.eth.getBalance(accounts[0]);
    console.log(balance);
    //web3.utils.fromWei(balance.toString(), "ether")は、weiをetherに変換するための命令
    //toString()は、balanceを文字列に変換するための命令
    let balanceInEth = web3.utils.fromWei(balance.toString(), "ether");
    console.log(balanceInEth) ;
})()