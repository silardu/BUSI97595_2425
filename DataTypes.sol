// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0; // solidity versions

contract DataTypes {
    // State variables are variables whose values are permanently stored in the contract's storage.
    // Boolean type
    bool public isActive = true; // Can hold true or false values.
    // Integer types
    int public integerVar = -42; // Signed integer: can store negative and positive values.
    uint public unsignedIntegerVar = 42; // Unsigned integer: can only store positive values (and zero).
    // Address type
    address public owner = 0x1234567890123456789012345678901234567890; // Holds an Ethereum address.
    // Fixed-size byte arrays
    bytes1 public byteVar = 0x01; // A single byte.
    bytes32 public largeByteVar = 0x1234567890123456789012345678901234567890123456789012345678901234; // Up to 32 bytes.
    // Dynamically-sized byte arrays
    bytes public dynamicBytes = "Hello, World!"; // Can hold a dynamically-sized array of bytes.
    // Strings
    string public greeting = "Hello, Solidity!"; // Holds text data.
    // Arrays
    uint[] public numbers = [1, 2, 3]; // Dynamic array of unsigned integers.
    uint[3] public fixedNumbers = [4, 5, 6]; // Fixed-size array of unsigned integers.
    // Mappings (key-value store)
    mapping(address => uint) public balances; // Maps an address to a uint balance.
    // Enums (enumerated list of possible values)

    enum Status {Pending, Shipped, Delivered} // Define possible statuses - these are assigned to sequential integers starting from 1
    Status public currentStatus = Status.Pending; // Set the default status
    
    // Structs (custom data structures)
    struct Product {
        string name;
        uint price;
    }

    Product public product = Product("Book", 100); // Initialize a struct.
    
    // Constructor (runs once at contract deployment)
    constructor() {
        owner = msg.sender; // Sets the owner to the address deploying the contract.
        // Notice we did not use tx.origin - any ideas why that might be?
    }

}

