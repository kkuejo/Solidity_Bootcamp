// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import "./Crowdsale.sol";

/**
 * @title MyTokenSale
 * @dev MyTokenSale is a Crowdsale contract for selling MyToken
 */
contract MyTokenSale is Crowdsale {
    constructor(
        uint256 rate_,    // rate in TKNbits
        address payable wallet_,
        IERC20 token_
    ) Crowdsale(rate_, wallet_, token_) {
        // MyTokenSale specific initialization can be added here
    }
}