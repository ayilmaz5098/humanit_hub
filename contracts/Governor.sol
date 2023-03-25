// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Governor {
    struct Proposal {
        address proposer;
        uint votingPower;
        bool executed;
        bool passed;
        uint votesFor;
        uint votesAgainst;
        uint endTime;
        string description;
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;
    mapping(address => bool) public members;
    mapping(address => uint) public votingPower;

    function addMember(address _member, uint _votingPower) public {
        require(!members[_member], "Member already exists");
        members[_member] = true;
        votingPower[_member] = _votingPower;
    }

    function removeMember(address _member) public {
        require(members[_member], "Member doesn't exist");
        members[_member] = false;
        votingPower[_member] = 0;
    }

    function propose(string memory _description) public returns (uint) {
        require(members[msg.sender], "Not a member");
        uint proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.proposer = msg.sender;
        proposal.votingPower = votingPower[msg.sender];
        proposal.endTime = block.timestamp + 1 days;
        proposal.description = _description;
        return proposalId;
    }

    function vote(uint _proposalId, bool _support) public {
        require(members[msg.sender], "Not a member");
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp < proposal.endTime, "Voting has ended");
        uint votePower = votingPower[msg.sender];
        if (_support) {
            proposal.votesFor += votePower;
        } else {
            proposal.votesAgainst += votePower;
        }
    }

    function execute(uint _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp >= proposal.endTime, "Voting hasn't ended");
        proposal.executed = true;
        if (proposal.votesFor > proposal.votesAgainst) {
            proposal.passed = true;
        }
    }

    function cancelProposal(uint _proposalId) public {
    require(members[msg.sender], "Not a member");
    Proposal storage proposal = proposals[_proposalId];
    require(proposal.proposer == msg.sender, "Only proposer can cancel proposal");
    require(!proposal.executed, "Proposal already executed");
    require(block.timestamp < proposal.endTime, "Voting has ended");
    proposal.executed = true;
    proposal.passed = false;
}
}
