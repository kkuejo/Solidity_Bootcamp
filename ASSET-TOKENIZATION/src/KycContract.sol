// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title KycContract
 * @dev KYC (Know Your Customer) contract for managing approved addresses
 * Only KYC-approved addresses can participate in the token sale
 */
contract KycContract is Ownable {
    mapping(address => bool) private _kycCompleted;

    event KycCompleted(address indexed account);
    event KycRevoked(address indexed account);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Approve an address for KYC
     * @param _addr Address to approve
     */
    function setKycCompleted(address _addr) public onlyOwner {
        require(_addr != address(0), "KycContract: address is the zero address");
        _kycCompleted[_addr] = true;
        emit KycCompleted(_addr);
    }

    /**
     * @dev Revoke KYC approval for an address
     * @param _addr Address to revoke
     */
    function setKycRevoked(address _addr) public onlyOwner {
        require(_addr != address(0), "KycContract: address is the zero address");
        _kycCompleted[_addr] = false;
        emit KycRevoked(_addr);
    }

    /**
     * @dev Check if an address is KYC approved
     * @param _addr Address to check
     * @return bool true if approved, false otherwise
     */
    function kycCompleted(address _addr) public view returns(bool) {
        return _kycCompleted[_addr];
    }
}