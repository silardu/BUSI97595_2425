// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract SimpleLendingPool {
    IERC20 public token;

    // Track deposited amounts
    mapping(address => uint256) public deposits;

    // Track borrowed amounts
    mapping(address => uint256) public borrows;

    // Simple interest rate (e.g. 1% = 100, scaled by 10,000)
    uint256 public interestRate = 100; // 1%

    constructor(address _token) {
        token = IERC20(_token);
    }

    // Deposit tokens into the pool
    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be > 0");
        token.transferFrom(msg.sender, address(this), _amount);
        deposits[msg.sender] += _amount;
    }

    // Withdraw deposited tokens
    function withdraw(uint256 _amount) external {
        require(deposits[msg.sender] >= _amount, "Insufficient deposit");
        deposits[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
    }

    // Borrow tokens (cannot exceed total deposits minus total borrowed)
    function borrow(uint256 _amount) external {
        require(_amount > 0, "Amount must be > 0");
        uint256 available = token.balanceOf(address(this));
        require(available >= _amount, "Not enough liquidity");
        borrows[msg.sender] += _amount;
        token.transfer(msg.sender, _amount);
    }

    // Repay borrowed tokens + simple interest
    function repay(uint256 _amount) external {
        require(borrows[msg.sender] > 0, "No active borrow");
        uint256 interest = (_amount * interestRate) / 10000;
        uint256 totalOwed = _amount + interest;
        require(token.balanceOf(msg.sender) >= totalOwed, "Not enough balance to repay");
        require(token.allowance(msg.sender, address(this)) >= totalOwed, "Not enough allowance");

        borrows[msg.sender] -= _amount;
        token.transferFrom(msg.sender, address(this), totalOwed);
    }
}