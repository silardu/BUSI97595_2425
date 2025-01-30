// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Escrow {
    address public payer;
    address public payee;
    address public lawyer;
    uint256 public amount;


    // Constructor should the escrow contract with the payer, payee, and agreed amount
    constructor() {

    }

    // This function should allow the payer to deposit Ether into the escrow contract
    // It requires the caller to be the payer and ensures deposits don't exceed the agreed amount
    // Ether is sent by attaching a `msg.value` with the function call

    function deposit()  {
    }

    // This function allows the lawyer to release funds to the payee when conditions are met
    // It can only be called by the lawyer and requires the contract balance to match the agreed amount
    function release() public { 
        payable(payee).transfer(amount);  // The payable modifier allows the address to transfer of Ether
    }

    // This is a view function that does not modify the state
    // The balance of Ether currently held in the contract
    function balanceOf() public view returns (uint256) {
        return address(this).balance;
    }
}