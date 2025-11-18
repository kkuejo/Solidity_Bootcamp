// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ItemManager.sol";

contract ItemManagerTest is Test {
    ItemManager public itemManager;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x1);
        itemManager = new ItemManager();
    }

    function testCreateItem() public {
        string memory itemName = "TestItem";
        uint256 itemPrice = 100;

        itemManager.createItem(itemName, itemPrice);

        (Item item, , string memory identifier) = itemManager.items(0);
        assertEq(identifier, itemName);
        assertEq(item.priceInWei(), itemPrice);
    }

    function testPaymentFlow() public {
        string memory itemName = "TestItem";
        uint256 itemPrice = 100 wei;

        itemManager.createItem(itemName, itemPrice);
        (Item item, , ) = itemManager.items(0);

        // ユーザーが支払い
        vm.deal(user, 1 ether);
        vm.prank(user);
        (bool success, ) = address(item).call{value: itemPrice}("");
        assertTrue(success);

        // ステータス確認
        (, ItemManager.SupplyChainSteps step, ) = itemManager.items(0);
        assertEq(uint256(step), uint256(ItemManager.SupplyChainSteps.Paid));
    }
}
