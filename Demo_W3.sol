// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// The contract should allow a user to set a personal note, then should be viewed only after a certain time passes. 
// Optionally, you can write one more function to extend the unlock time. Only owner should be able to set and unlock the message. 

contract TimeLockedMessage {
    address public owner;
    string private message;
    uint256 public unlockTime;
    uint256 public createdAt;

    constructor(address _owner, uint256 _unlockTime) {
        owner = _owner;
        unlockTime = _unlockTime;
        createdAt = block.timestamp;
    }

    // Function to set the message (only owner can set it)
    function setMessage(string memory _message) public {
        require(msg.sender == owner, "Not authorized");
        message = _message;
    }
    
    // Function to view the message after unlock time
     function viewMessage() public view returns (string memory) {
        require(block.timestamp >= unlockTime, "Message is locked");
        require(msg.sender == owner, "Not authorized");
        return message;
    }

   
    // Function to extend the unlock time (only owner can extend)
     function extendUnlockTime(uint256 _newUnlockTime) public {
        require(msg.sender == owner, "Not authorized");
        unlockTime = _newUnlockTime;
    }
}