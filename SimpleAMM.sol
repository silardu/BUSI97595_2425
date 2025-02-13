// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract SimpleAMM {
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    uint256 public reserveA;
    uint256 public reserveB;
    
    // k is set once liquidity is initialized and remains constant
    uint256 public k;
    
    // Flag to ensure liquidity is only initialized once
    bool public liquidityInitialized;
    
    /*
      Steps to deploy and interact with this contract in Remix:
      
      1. Deploy two ERC20 token contracts (or use mock tokens).
         - Ensure your account holds sufficient token balances.
      
      2. Deploy the SimpleAMM contract by providing the addresses of the two tokens.
         - Note: Liquidity is not added during deployment.
      
      3. Before adding liquidity, call 'approve' on both token contracts.
         - Approve the SimpleAMM contract address to spend the desired amounts.
      
      4. Call 'initializeLiquidity' on the deployed SimpleAMM contract.
         - Provide the amounts of tokenA and tokenB you wish to add as liquidity.
         - This function can only be called once.
      
      5. Once liquidity is initialized, you can call 'swapAForB' or 'swapBForA' to perform swaps.
    */
    
    // Constructor sets the token addresses; liquidity is added later via initializeLiquidity.
    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    
    // Initialize liquidity by transferring tokens from msg.sender to the contract.
    // Can only be called once.
    function initializeLiquidity(uint256 amountA, uint256 amountB) external {
        require(!liquidityInitialized, "Liquidity already initialized");
        
        // Ensure that the caller has approved this contract to spend their tokens.
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "TokenA transfer failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "TokenB transfer failed");
        
        reserveA = amountA;
        reserveB = amountB;
        
        // Set k as the product of the initial reserves.
        k = reserveA * reserveB;
        liquidityInitialized = true;
    }
    
    // Swap tokenA for tokenB (no fee)
    function swapAForB(uint256 amountAIn) external {
        require(liquidityInitialized, "Liquidity not initialized");
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "TokenA transfer failed");
        
        uint256 newReserveA = reserveA + amountAIn;
        // Calculate tokenB output using constant product formula: amountBOut = reserveB - (k / newReserveA)
        uint256 amountBOut = reserveB - (k / newReserveA);
        require(amountBOut > 0, "Insufficient output amount");
        
        reserveA = newReserveA;
        reserveB = reserveB - amountBOut;
        
        require(tokenB.transfer(msg.sender, amountBOut), "TokenB transfer failed");
    }
    
    // Swap tokenB for tokenA (no fee)
    function swapBForA(uint256 amountBIn) external {
        require(liquidityInitialized, "Liquidity not initialized");
        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "TokenB transfer failed");
        
        uint256 newReserveB = reserveB + amountBIn;
        // Calculate tokenA output using constant product formula: amountAOut = reserveA - (k / newReserveB)
        uint256 amountAOut = reserveA - (k / newReserveB);
        require(amountAOut > 0, "Insufficient output amount");
        
        reserveB = newReserveB;
        reserveA = reserveA - amountAOut;
        
        require(tokenA.transfer(msg.sender, amountAOut), "TokenA transfer failed");
    }
}
