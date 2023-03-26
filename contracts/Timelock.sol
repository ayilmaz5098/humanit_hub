// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Governor.sol";

contract Timelock {

    address public owner;
    uint public releaseTime;
    mapping(bytes32 => bool) public queuedTransactions;

   constructor(uint _releaseTime) {
    owner = msg.sender;
    releaseTime = _releaseTime;
    }

   function release() public {
    require(msg.sender == owner, "Only the owner can release the funds");
    require(block.timestamp >= releaseTime, "Release time has not yet arrived");

    // Transfer the balance of this contract to the owner
    uint balance = address(this).balance;
    payable(owner).transfer(balance);
    }

}
