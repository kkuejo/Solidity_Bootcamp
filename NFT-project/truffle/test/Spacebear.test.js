//テストは、次の2つのコンポーネントで構成されている。
//1. トランザクションの実行
//2. ブロックチェーン上の状態または、トランザクションの結果を期待値と比較する。

//デプロイの手順は以下の通り。
//1. Ganacheを起動　(ganacheコマンドを実行)
//2. コントラクトをコンパイル　(truffle compile)
//3. コントラクトをデプロイ　(truffle migrate --network ganache)
//4. テストの実行 (truffle test)
//または、以下のようにコンソールを起動し、コントラクトと直接対話することができる。
//1. Ganacheを起動　(ganacheコマンドを実行)
//2. コントラクトをコンパイル　(truffle compile)　(必須ではない)
//3. コントラクトをデプロイ　(truffle migrate --network ganache)
//4. コンソールを起動 (truffle console --network ganache)
//5. テストの実行 (testと入力)



//テストを実行するために、Spacebearコントラクトをインポートする。
//artifacts.require("Spacebear")は、コントラクトをインポートするための関数である。
//Truffleのプロジェクトでは、build/contracts/ディレクトリに各コントラクトのアーティファクトファイル（.json）が保存される。
//このファイルには、以下の情報が含まれている。
//1. ABI: コントラクトの関数とイベントの定義
//2. Bytecode: コントラクトのコンパイルされたコード
//3. ソースマップ: コントラクトのソースコードとコンパイルされたコードのマッピング
//4. ネットワーク情報: デプロイ先のアドレスとトランザクションハッシュ
const Spacebear = artifacts.require("Spacebear");

//標準のassertでは以下のような検証が困難であるので、その際には、truffle-assertionsを使用する。
// - イベントが発行されたか
// - トランザクションが失敗したか
// - 特定のエラーメッセージが表示されたか
// - ガス使用量の検証

//node_modules/truffle-assertionsに、本機能の記載がある。
const truffleAssert = require('truffle-assertions');

/*
contract("Spacebear", (accounts) => {
    it('should credit an NFT to a specific account', async () => {
        //デプロイ済のSpacebearコントラクトのインスタンスを取得
        const spacebearInstance = await Spacebear.deployed();
        //safeMintは、NFTをmintする関数である。
        //accounts[1]は、NFTを受け取る人のアドレスを表す。
        //"spacebear_1.json"は、NFTのメタデータのURLを表す。
        await spacebearInstance.safeMint(accounts[1],"spacebear_1.json");
        //ownerOfは、NFTの所有者を取得する関数である。
        //NFTID(ownerOfの引数)0の所有者が、accounts[1]であることを確認する。
        //accounts[0]に変更するとエラーが出る。
        
        //assertは期待値を実際の値が一致することを確認する機能を表している。
        //Truffleのテストフレームワークでは、Node.jsの以下の標準モジュールを使用することができる。
        //assert.equal(actual, expected, message)    // 等しいことを確認
        //assert.notEqual(actual, expected, message) // 等しくないことを確認
        //assert.isTrue(value, message)              // trueであることを確認
        //assert.isFalse(value, message)             // falseであることを確認
        //assert.isAbove(value, limit, message)      // 値が上限より大きいことを確認
        //assert.isBelow(value, limit, message)      // 値が下限より小さいことを確認
        
        assert.equal(await spacebearInstance.ownerOf(0), accounts[1], "Owner of Token is the wrong address");
    })
})
*/

/*
contract("Spacebear", (accounts) => {
    //itが個別の1つテストケースを定義し、この中でassert文が5つあり、5つの検証項目がある状況。
    it('should credit an NFT to a specific account', async () => {
        //デプロイ済のSpacebearコントラクトのインスタンスを取得
        const spacebearInstance = await Spacebear.deployed();
        //safeMintは、NFTをmintする関数である。
        //accounts[1]は、NFTを受け取る人のアドレスを表す。
        //"spacebear_1.json"は、NFTのメタデータのURLを表す。
        //txResultは「Transaction Result（トランザクション結果）」の略で、ブロックチェーン上で実行されたトランザクションの詳細な結果情報を格納するオブジェクトである。
        
        //txResultには以下の情報が含まれている。
        //txHash: トランザクションのハッシュ
        //blockNumber: トランザクションが含まれるブロックの番号
        //gasUsed: トランザクションで使用されたガスの量
        //gasPrice: トランザクションで使用されたガスの価格
        //status: トランザクションのステータス

        //イベントログには以下のようなもの含まれている。
        //logs: トランザクションで発生したイベントのログ
        //logs[0].event: イベントの名前
        //logs[0].args.from: トークンの送信者のアドレス
        //logs[0].args.to: トークンの受信者のアドレス
        //logs[0].args.tokenId: トークンのID

        let txResult = await spacebearInstance.safeMint(accounts[1],"spacebear_1.json");
 
        //ERC721のの仕様で、ミント時には、ゼロアドレスから、ミント先のアドレスに、0から順のトークンIDが付与される。
        assert.equal(txResult.logs[0].event, "Transfer", "Transfer event was not emitted")
        assert.equal(txResult.logs[0].args.from, '0x0000000000000000000000000000000000000000', "Token was not transferred from the zero address");
        assert.equal(txResult.logs[0].args.to, accounts[1], "Receiver wrong address");
        assert.equal(txResult.logs[0].args.tokenId.toString(), "0", "Wrong Token ID minted");
 
        assert.equal(await spacebearInstance.ownerOf(0), accounts[1], "Owner of Token is the wrong address");
    })
})
*/

contract("Spacebear", (accounts) => {
    it('should credit an NFT to a specific account', async () => {
        const spacebearInstance = await Spacebear.deployed();
        let txResult = await spacebearInstance.safeMint(accounts[1],"spacebear_1.json");
        
        //Transferイベントの詳細な検証を行う。
        //truffleAssert.eventEmittedの第一変数は、txResultを検証するという意味。
        //第二変数は、イベントの名前を指定する。(transferやApprovalなどがERC721で定義されている。)
        //第三変数は、イベントの引数を指定する。(from: '0x0000000000000000000000000000000000000000', to: accounts[1], tokenId: web3.utils.toBN("0")})
        //web3.utils.toBN("0")は、web3.jsのtoBN関数を使用して、0をBN型にリキャストしている。
        //Sokidityではuint256型であるが、JavaScriptのnumberは64ビットの浮動小数点、BN型は可変長整数である。
        truffleAssert.eventEmitted(txResult, 'Transfer', {from: '0x0000000000000000000000000000000000000000', to: accounts[1], tokenId: web3.utils.toBN("0")});
 
        assert.equal(await spacebearInstance.ownerOf(0), accounts[1], "Owner of Token is the wrong address");
    })
})