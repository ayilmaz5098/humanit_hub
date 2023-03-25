// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    mapping(address => uint) public balances;
    uint public totalSupply;

    function mint(address _to, uint _amount) public {
        balances[_to] += _amount;
        totalSupply += _amount;
    }

    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
