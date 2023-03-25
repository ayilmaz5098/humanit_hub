// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timelock {
    Governor public governor;
    uint public delay;
    uint public earliestExecution;
    mapping(bytes32 => bool) public queuedTransactions;

    constructor(Governor _governor, uint _delay) {
        governor = _governor;
        delay = _delay;
    }

    function queueTransaction(address _target, uint _value, string memory _signature, bytes memory _data, uint _eta) public returns (bytes32) {
        require(msg.sender == address(governor), "Only governor can queue transactions");
        bytes32 txHash = keccak256(abi.encode(_target, _value, _signature, _data, _eta));
        queuedTransactions[txHash] = true;
        earliestExecution = _eta + delay;
        return txHash;
    }

    function cancelTransaction(address _target, uint _value, string memory _signature, bytes memory _data, uint _eta) public {
        require(msg.sender == address(governor), "Only governor can cancel transactions");
        bytes32 txHash = keccak256(abi.encode(_target, _value, _signature, _data, _eta));
        queuedTransactions[txHash] = false;
    }

    function executeTransaction(address _target, uint _value, string memory _signature, bytes memory _data, uint _eta) public payable returns (bytes memory) {
        require(msg.sender == address(governor), "Only governor can execute transactions");
        bytes32 txHash = keccak256(abi.encode(_target, _value, _signature, _data, _eta));
        require(queuedTransactions[txHash], "Transaction hasn't been queued");
        require(block.timestamp >= earliestExecution, "Transaction hasn't reached earliest execution time");

        queuedTransactions[txHash] = false;

        (bool success, bytes memory ret) = _target.call{value:_value}(abi.encodePacked(bytes4(keccak256(bytes(_signature))), _data));
        require(success, "Transaction execution failed");

        return ret;
    }
}
