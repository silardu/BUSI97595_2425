// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLendingPool {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;
    mapping(address => uint256) public collateral;
    uint256 public interestRate = 100; // 1% interest rate
    uint256 public collateralRatio = 150; // 150% collateral requirement

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 amount, uint256 interest);
    event CollateralDeposited(address indexed user, uint256 amount);
    event CollateralWithdrawn(address indexed user, uint256 amount);

    // Deposit ETH into the pool
    function deposit() external payable {
        require(msg.value > 0, "Amount must be > 0");
        deposits[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw deposited ETH
    function withdraw(uint256 _amount) external {
        require(deposits[msg.sender] >= _amount, "Insufficient deposit");
        deposits[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    // Deposit collateral
    function depositCollateral() external payable {
        require(msg.value > 0, "Amount must be > 0");
        collateral[msg.sender] += msg.value;
        emit CollateralDeposited(msg.sender, msg.value);
    }

    // Withdraw collateral
    function withdrawCollateral(uint256 _amount) external {
        require(collateral[msg.sender] >= _amount, "Insufficient collateral");
        require(borrows[msg.sender] == 0, "Cannot withdraw collateral while owing debt");
        collateral[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit CollateralWithdrawn(msg.sender, _amount);
    }

    // Borrow ETH from the pool
    function borrow(uint256 _amount) external {
        require(_amount > 0, "Amount must be > 0");
        require(address(this).balance >= _amount, "Not enough liquidity");
        require(collateral[msg.sender] * 100 / collateralRatio >= _amount, "Insufficient collateral");
        borrows[msg.sender] += _amount;
        payable(msg.sender).transfer(_amount);
        emit Borrowed(msg.sender, _amount);
    }

    // Repay borrowed ETH with interest
    function repay() external payable {
        require(borrows[msg.sender] > 0, "No active borrow");
        uint256 interest = (borrows[msg.sender] * interestRate) / 10000;
        uint256 totalOwed = borrows[msg.sender] + interest;
        require(msg.value >= totalOwed, "Insufficient repayment amount");
        
        borrows[msg.sender] = 0;
        emit Repaid(msg.sender, msg.value, interest);
    }

    // Get contract balance (total liquidity available in the pool)
    function getPoolBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Get the total amount a user owes, including interest
    function getTotalOwed(address _user) external view returns (uint256) {
        uint256 interest = (borrows[_user] * interestRate) / 10000;
        return borrows[_user] + interest;
    }
}
