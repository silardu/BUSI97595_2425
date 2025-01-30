// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Voting {
    // Represents a voter in the system
    struct Voter {
        bool voted;        // Indicates whether the voter has already voted
        uint8 vote;        // Stores the index of the proposal the voter chose
        uint256 weight;    // Voting weight of the voter, typically 1
    }

    // Represents a proposal in the voting system
    struct Proposal {
        uint256 voteCount; // Tracks the total number of votes for the proposal
    }

    address public chairperson;            // Address of the individual managing the voting process
    mapping(address => Voter) public voters; // Maps each voter's address to their corresponding Voter structure
    Proposal[] public proposals;           // Dynamic array of proposals being voted on

    // Constructor sets up the voting system with the specified number of proposals
    constructor(uint8 _numProposals) {
        chairperson = msg.sender;           // Assigns the contract creator as the chairperson
        voters[chairperson].weight = 1;     // Grants the chairperson an initial vote weight of 1
        for (uint8 i = 0; i < _numProposals; i++) {
            proposals.push(Proposal(0));    // Initializes each proposal with zero votes
        }
    }

    // Allows the chairperson to register a new voter
    function register(address voter) public {
        require(msg.sender == chairperson, "Only chairperson can register"); // Ensures only the chairperson can call this function
        require(!voters[voter].voted, "The voter already voted");           // Ensures the voter has not already voted
        voters[voter].weight = 1;                                           // Assigns a voting weight of 1 to the voter
    }

    // Allows a voter to cast their vote for a specific proposal
    function vote(uint8 proposal) public {
        Voter storage sender = voters[msg.sender]; // Access the voter's record using their address
        require(sender.weight != 0, "Has no right to vote"); // Ensures the voter has the right to vote
        require(!sender.voted, "Already voted");            // Ensures the voter has not already voted
        sender.voted = true;                                // Marks the voter as having voted
        sender.vote = proposal;                             // Records the index of the chosen proposal
        proposals[proposal].voteCount += sender.weight;     // Increments the vote count of the selected proposal by the voter's weight
    }

    // Determines which proposal has the most votes and returns its index
    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;                       // Variable to track the highest vote count
        for (uint8 p = 0; p < proposals.length; p++) {      // Iterate over all proposals
            if (proposals[p].voteCount > winningVoteCount) { // Check if the current proposal has more votes
                winningVoteCount = proposals[p].voteCount;  // Update the highest vote count
                _winningProposal = p;                       // Update the index of the winning proposal
            }
        }
    }
}