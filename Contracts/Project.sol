// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVoting {
    address public owner;
    string[] public candidates;
    mapping(string => uint256) public votes;
    mapping(address => bool) public hasVoted;

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
    }

    /// @notice Cast a vote for a candidate
    function vote(string memory _candidate) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(validCandidate(_candidate), "Invalid candidate.");

        votes[_candidate] += 1;
        hasVoted[msg.sender] = true;
    }

    /// @notice Get total votes of a candidate
    function getVotes(string memory _candidate) public view returns (uint256) {
        require(validCandidate(_candidate), "Invalid candidate.");
        return votes[_candidate];
    }

    /// @notice Get the candidate with the most votes
    function getWinner() public view returns (string memory winner) {
        uint256 maxVotes = 0;
        string memory winnerCandidate = "";

        for (uint256 i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > maxVotes) {
                maxVotes = votes[candidates[i]];
                winnerCandidate = candidates[i];
            }
        }

        return winnerCandidate;
    }

    /// @dev Internal helper to check if candidate is valid
    function validCandidate(string memory _candidate) internal view returns (bool) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                keccak256(abi.encodePacked(candidates[i])) ==
                keccak256(abi.encodePacked(_candidate))
            ) {
                return true;
            }
        }
        return false;
    }
}
