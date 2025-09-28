// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Spacebear} from "../src/Spacebear.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

//Spacebearコントラクトが、Test.solを承継している。
contract SpacebearTest is Test {
    //Spacebearコントラクトのインスタンスを、spacebearという名前で宣言。
    Spacebear spacebear;

    //setUp関数を実行すると、Test.solで定義されている関数で、テストの準備を行うための特別な関数。
    function setUp() public {
        spacebear = new Spacebear(address(this));
    }

   //Spacebearコントラクトの名前を取得し、それが期待した名前と一致していることを確認。
   //コントラクトの情報を変更する必要がないため、viewとすることで、コンパイラが効率的に処理する。 
    function testNameIsSpacebear() public view {
        assertEq(spacebear.name(), "Spacebear");
    }

    //NFTをmintするテスト。
    //トークンの所有者がmsg.senderであることを確認。
    //トークンのURIが期待したURIと一致していることを確認。
    function testMintingNFTs() public {
        spacebear.safeMint(msg.sender);
        assertEq(spacebear.ownerOf(0), msg.sender);
        assertEq(spacebear.tokenURI(0), "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_1.json");
    }

    //オーナー以外がミントできないことを確認。
    function testNftCreationWrongOwner() public {
        //purchaserとして、オーナーではないアカウントを設定。
        address purchaser = address(0x1);
        //Foundryのvm.startPrankを使用して、msg.senderをpurchaserに変更。
        //これにより、purchaserが関数を呼び出している状態をシミュレート
        vm.startPrank(purchaser);
        //この次の関数(spacebear.safeMint(purchaser))で、引数のようなエラーが出ることを期待。
        //ABI形式での予測されるエラーを指定。
        //abi.encodeWithSelectorは、Solidityの組み込み関数。
        //以下が、OppenZeppelineで定義されている。
        //Ownable:オーナーの権限管理を実装
        //OwnableUnauthorizedAccount:オーナー以外が実行できないことを実装
        //.selector:エラーのセレクタを指定。(エラーのセレクタは、エラーの種類を示す。0x82b42900は、OwnableUnauthorizedAccountのセレクタ。)
        //下のspacebear.safeMint(purchaser);で出力されるエラーが、エラーの種類とどのアカウントがエラーを起こしたかの情報を含むために、これら2つの情報を含むように記述。
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, purchaser));
        //オーナーしか実行できないsafeMintを非オーナーが実行。エラーが出るはず。
        spacebear.safeMint(purchaser);
        //権限のリセット。msg.senderを元に戻す。
        vm.stopPrank();
    }

    //NFTを購入するテスト。
    function testNftBuyToken() public {
         //purchaserとして、オーナーではないアカウントを設定。       
        address purchaser = address(0x2);
        //purchaserに1 ETHを送金
        vm.deal(purchaser, 1 ether); // テストアカウントに1 ETHを送金
        //Foundryのvm.startPrankを使用して、msg.senderをpurchaserに変更。
        vm.startPrank(purchaser);
        //0.1 ETHを送金して、NFTを購入。
        spacebear.buyToken{value: 0.1 ether}();
        //権限のリセット。msg.senderを元に戻す。
        vm.stopPrank();
        //トークンID 0の所有者がpurchaserであることを確認。
        assertEq(spacebear.ownerOf(0), purchaser);
    }

}