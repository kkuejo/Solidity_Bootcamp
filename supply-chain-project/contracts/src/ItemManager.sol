// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    enum SupplyChainSteps {
        Created,
        Paid,
        Delivered
    }

    struct S_Item {
        Item item;
        SupplyChainSteps step;
        string identifier;
    }

    mapping(uint256 => S_Item) public items;
    uint256 public itemIndex;

    event SupplyChainStep(
        uint256 indexed itemIndex,
        uint256 step,
        address itemAddress
    );

    function createItem(string memory _identifier, uint256 _priceInWei)
        public
        onlyOwner
    {
        Item item = new Item(address(this), _priceInWei, itemIndex);
        items[itemIndex].item = item;
        items[itemIndex].step = SupplyChainSteps.Created;
        items[itemIndex].identifier = _identifier;

        emit SupplyChainStep(itemIndex, uint256(SupplyChainSteps.Created), address(item));
        itemIndex++;
    }

    function triggerPayment(uint256 _index) public payable {
        Item item = items[_index].item;
        require(
            address(item) == msg.sender,
            "Only items are allowed to update themselves"
        );
        require(
            item.priceInWei() == msg.value,
            "Not fully paid yet"
        );
        require(
            items[_index].step == SupplyChainSteps.Created,
            "Item is further in the supply chain"
        );

        items[_index].step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint256(SupplyChainSteps.Paid), address(item));
    }

    function triggerDelivery(uint256 _index) public onlyOwner {
        require(
            items[_index].step == SupplyChainSteps.Paid,
            "Item is further in the supply chain"
        );
        
        items[_index].step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(
            _index,
            uint256(SupplyChainSteps.Delivered),
            address(items[_index].item)
        );
    }
}
