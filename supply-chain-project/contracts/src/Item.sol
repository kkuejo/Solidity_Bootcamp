// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Item {
    uint256 public priceInWei;
    uint256 public paidWei;
    uint256 public index;
    address public parentContract;

    constructor(
        address _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(msg.value == priceInWei, "We don't support partial payments");
        require(paidWei == 0, "Item is already paid!");

        paidWei += msg.value;

        (bool success, ) = parentContract.call{value: msg.value}(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );
        require(success, "Payment trigger failed");
    }

    fallback() external {}
}
