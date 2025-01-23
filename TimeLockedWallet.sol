// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ;

contract TimeLockedWallet {
    address public owner;
    address public beneficiary;
    uint256 public unlockDate;
    uint256 public createdAt;

    constructor(address _owner, address _beneficiary, uint256 _unlockDate)  {
        owner = _owner;
        beneficiary = _beneficiary;
        unlockDate = _unlockDate;
        createdAt = block.timestamp;
    }

    // Function to deposit funds into the smart contract
    function deposit() external payable {}

    // Function to withdraw funds after the unlock date
    // Require reverts the entire state change, and aborts the whole process, it is more gas efficient and safer than an "if" function 
    function withdraw() external {
        require(block.timestamp >= unlockDate, "Funds are locked");
        require(msg.sender == beneficiary, "Not authorized");
        payable(beneficiary).transfer(address(this).balance);
    }

    // Function to view the balance of the contract
    function getBalance() external view returns(uint) {
        return(address(this).balance);
    }
}

