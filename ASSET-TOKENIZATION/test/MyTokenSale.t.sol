// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/MyTokenSale.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyTokenSaleTest is Test {
    MyToken public token;
    MyTokenSale public tokenSale;

    address public wallet;
    address public buyer1;
    address public buyer2;

    uint256 public constant INITIAL_SUPPLY = 1000000;
    uint256 public constant RATE = 1; // 1 wei = 1 token

    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    // ETHを受け取るためのreceive関数
    receive() external payable {}

    function setUp() public {
        wallet = makeAddr("wallet"); // ETHを受け取るウォレット
        buyer1 = address(0x1);
        buyer2 = address(0x2);

        // MyTokenをデプロイ
        token = new MyToken(INITIAL_SUPPLY);

        // MyTokenSaleをデプロイ
        tokenSale = new MyTokenSale(
            RATE,
            payable(wallet),
            IERC20(address(token))
        );

        // 全トークンをTokenSaleコントラクトに転送
        token.transfer(address(tokenSale), INITIAL_SUPPLY);
    }

    // デプロイヤーは初期状態でトークンを持っていない
    function testDeployerHasNoTokens() public view {
        assertEq(token.balanceOf(address(this)), 0);
    }

    // 全トークンがTokenSaleコントラクトにある
    function testAllTokensInTokenSale() public view {
        uint256 tokenSaleBalance = token.balanceOf(address(tokenSale));
        uint256 totalSupply = token.totalSupply();
        assertEq(tokenSaleBalance, totalSupply);
    }

    // トークン購入が可能
    function testBuyTokens() public {
        uint256 weiAmount = 100;
        uint256 expectedTokens = weiAmount * RATE;

        // buyer1の初期残高を確認
        uint256 balanceBefore = token.balanceOf(buyer1);
        assertEq(balanceBefore, 0);

        // イベントが発火されることを期待
        vm.expectEmit(true, true, false, true);
        emit TokensPurchased(buyer1, buyer1, weiAmount, expectedTokens);

        // buyer1がトークンを購入
        vm.deal(buyer1, 1 ether); // buyer1に1 ETHを付与
        vm.prank(buyer1);
        tokenSale.buyTokens{value: weiAmount}(buyer1);

        // buyer1の残高を確認
        uint256 balanceAfter = token.balanceOf(buyer1);
        assertEq(balanceAfter, expectedTokens);
    }

    // ETHを直接送信してトークンを購入
    function testBuyTokensViaReceive() public {
        uint256 weiAmount = 50;
        uint256 expectedTokens = weiAmount * RATE;

        // buyer2に1 ETHを付与
        vm.deal(buyer2, 1 ether);

        // buyer2の初期残高を確認
        uint256 balanceBefore = token.balanceOf(buyer2);
        assertEq(balanceBefore, 0);

        // buyer2がETHを直接送信（receive関数が呼ばれる）
        vm.prank(buyer2);
        (bool success, ) = address(tokenSale).call{value: weiAmount}("");
        require(success, "ETH transfer failed");

        // buyer2の残高を確認
        uint256 balanceAfter = token.balanceOf(buyer2);
        assertEq(balanceAfter, expectedTokens);
    }

    // 0 weiでの購入は失敗
    function testCannotBuyWithZeroWei() public {
        vm.prank(buyer1);
        vm.expectRevert("Crowdsale: weiAmount is 0");
        tokenSale.buyTokens{value: 0}(buyer1);
    }

    // ゼロアドレスへの購入は失敗
    function testCannotBuyToZeroAddress() public {
        vm.deal(buyer1, 1 ether);
        vm.prank(buyer1);
        vm.expectRevert("Crowdsale: beneficiary is the zero address");
        tokenSale.buyTokens{value: 100}(address(0));
    }

    // 複数の購入者がトークンを購入可能
    function testMultipleBuyers() public {
        uint256 weiAmount1 = 100;
        uint256 weiAmount2 = 200;

        // buyer1が購入
        vm.deal(buyer1, 1 ether);
        vm.prank(buyer1);
        tokenSale.buyTokens{value: weiAmount1}(buyer1);

        // buyer2が購入
        vm.deal(buyer2, 1 ether);
        vm.prank(buyer2);
        tokenSale.buyTokens{value: weiAmount2}(buyer2);

        // 残高を確認
        assertEq(token.balanceOf(buyer1), weiAmount1 * RATE);
        assertEq(token.balanceOf(buyer2), weiAmount2 * RATE);
    }

    // weiRaisedが正しく更新される
    function testWeiRaisedUpdated() public {
        uint256 weiAmount1 = 100;
        uint256 weiAmount2 = 200;

        // 初期状態
        assertEq(tokenSale.weiRaised(), 0);

        // buyer1が購入
        vm.deal(buyer1, 1 ether);
        vm.prank(buyer1);
        tokenSale.buyTokens{value: weiAmount1}(buyer1);
        assertEq(tokenSale.weiRaised(), weiAmount1);

        // buyer2が購入
        vm.deal(buyer2, 1 ether);
        vm.prank(buyer2);
        tokenSale.buyTokens{value: weiAmount2}(buyer2);
        assertEq(tokenSale.weiRaised(), weiAmount1 + weiAmount2);
    }

    // ETHがウォレットに転送される
    function testEthForwardedToWallet() public {
        uint256 weiAmount = 100;

        // ウォレットの初期ETH残高を確認
        uint256 walletBalanceBefore = wallet.balance;

        // buyer1が購入
        vm.deal(buyer1, 1 ether);
        vm.prank(buyer1);
        tokenSale.buyTokens{value: weiAmount}(buyer1);

        // ウォレットのETH残高が増加していることを確認
        uint256 walletBalanceAfter = wallet.balance;
        assertEq(walletBalanceAfter, walletBalanceBefore + weiAmount);
    }

    // Fuzz Test: ランダムな金額でトークンを購入
    function testFuzzBuyTokens(uint256 weiAmount) public {
        // weiAmountを1から10000の範囲に制限
        vm.assume(weiAmount > 0 && weiAmount <= 10000);
        vm.assume(weiAmount * RATE <= INITIAL_SUPPLY);

        uint256 expectedTokens = weiAmount * RATE;

        vm.deal(buyer1, 1 ether);
        vm.prank(buyer1);
        tokenSale.buyTokens{value: weiAmount}(buyer1);

        assertEq(token.balanceOf(buyer1), expectedTokens);
    }
}
