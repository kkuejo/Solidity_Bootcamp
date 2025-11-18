// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ItemManager.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ItemManager itemManager = new ItemManager();
        console.log("ItemManager deployed at:", address(itemManager));

        vm.stopBroadcast();
    }
}