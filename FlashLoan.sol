// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

///Mock on-chain flash loan provider
interface IFlashLoanReceiver {
    function executeOperation(uint256 amount) external;
}

contract FlashLoanUser is IFlashLoanReceiver {
    FlashLoanProvider public lender;
    address public owner;

    event ArbitrageSuccess(uint256 profit);

    constructor(address lenderAddress) {
        lender = FlashLoanProvider(lenderAddress);
        owner = msg.sender;
    }

    // Request a flash loan
    function startFlashLoan(uint256 amount) external {
        require(msg.sender == owner, "Only owner can execute");
        lender.flashLoan(amount, address(this));
    }

    // Executed once loan is received
    function executeOperation(uint256 amount) external override {
        require(msg.sender == address(lender), "Only lender can call");

        // 🔹 Simulated arbitrage trade (pretend we make a 5% profit)
        uint256 profit = (amount * 5) / 100;
        uint256 totalRepayment = amount + (amount * 5) / 1000; // Loan + 0.5% fee

        // Send the profit to the owner
        (bool profitSent, ) = owner.call{value: profit}("");
        require(profitSent, "Profit transfer failed");

        // Repay the loan
        (bool repaid, ) = payable(address(lender)).call{value: totalRepayment}("");
        require(repaid, "Loan repayment failed");

        emit ArbitrageSuccess(profit);
    }

    // Allow contract to receive ETH
    receive() external payable {}
}
