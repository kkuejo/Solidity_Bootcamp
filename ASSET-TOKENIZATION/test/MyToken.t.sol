// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public token;
    address public alice = address(0x1);
    address public bob = address(0x2);
    uint256 public constant INITIAL_SUPPLY = 1000000;
    address public owner;

    // テスト前に毎回実行される
    function setUp() public {
        owner = address(this);
        token = new MyToken(INITIAL_SUPPLY);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
    }

    function testTransfer() public {
        uint256 amount = 100;
        
        // トークンを転送
        token.transfer(alice, amount);
        
        // 残高チェック
        assertEq(token.balanceOf(alice), amount);
        assertEq(token.balanceOf(address(this)), INITIAL_SUPPLY - amount);
    }

    function testTransferEvent() public {
        uint256 amount = 100;
        
        // イベントが発火されることを期待
        vm.expectEmit(true, true, false, true);
        emit IERC20.Transfer(address(this), alice, amount);
        
        token.transfer(alice, amount);
    }

    function testRevertTransferInsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(bob, 100);
    }

    function testApproveAndTransferFrom() public {
        uint256 amount = 100;
        
        // aliceに代わってbobが転送できるように承認
        token.approve(bob, amount);
        assertEq(token.allowance(address(this), bob), amount);
        
        // bobがaliceに転送
        vm.prank(bob);
        token.transferFrom(address(this), alice, amount);
        
        assertEq(token.balanceOf(alice), amount);
    }

    // Fuzz Testing（ランダム入力テスト）
    function testFuzzTransfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(to != address(this));
        vm.assume(amount <= INITIAL_SUPPLY);
        
        token.transfer(to, amount);
        assertEq(token.balanceOf(to), amount);
    }
}