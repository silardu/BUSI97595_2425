// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0; 


contract FunctionTypes {
    // State Variables
    address public owner;
    mapping(address => uint) public balances;
    enum Status {Inactive, Active}
    uint private number1;

    Status public currentStatus;

    // Event declaration
    event StatusChanged(Status newStatus);

    // Constructor
    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        currentStatus = Status.Inactive; // Initialize the status
        balances[owner] = 0;
        number1 = 4;
    }

    // External Function
    function externalFunctionExample(uint amount) external {
        require(amount > 0, "Amount must be positive");
        balances[msg.sender] += amount;
    }

    // Public Function
    function changeStatus(Status newStatus) public {
        currentStatus = newStatus; // Update the current status
        emit StatusChanged(newStatus); // Log the status change
    }

    // Internal Function
    function internalFunctionExample() internal view returns (uint) {
        return balances[owner]; // Get the owner's balance
    }

    // Private Function
    function privateFunctionExample() private pure returns (string memory) {
        return "This is private!";
    }

    // View Function
    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    // Pure Function
    function addNumbers(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function sumNumbers(uint a, uint b) public view returns (uint) {
        uint sum = number1 + a + b;
        return sum;
    }

    // Utility to get the owner
    function getOwner() public view returns (address) {
        return owner;
    }
}
