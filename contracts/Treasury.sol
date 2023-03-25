// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Treasury {
    mapping(address => uint) public balances;

    function deposit(uint _amount) public payable {
        require(msg.value == _amount, "Amount doesn't match value");
        balances[msg.sender] += _amount;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}
