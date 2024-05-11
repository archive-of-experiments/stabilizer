
// File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.4/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol


pragma solidity >=0.5.0;

/// @title Callback for IUniswapV3PoolActions#swap
/// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
interface IUniswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

// File: https://raw.githubusercontent.com/Uniswap/v3-periphery/main/contracts/interfaces/ISwapRouter.sol


pragma solidity >=0.7.5;
pragma abicoder v2;


/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouter is IUniswapV3SwapCallback {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
}

// File: https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v0.0.1/IFreedomSwaps.sol



// We fund freedom.
// We stop state criminals.
// We make crypto cypherpunk again.
// We love Geo Caching with Geo Cash.
// We foster Freedom, Justice and Peace.
// We foster sustainable liquidity infrastructures.
// We combine Crypto Education with Geo Caching.
// We separate money from state criminals like religion has been separated from state.
// We foster ever emerging architectures of freedom by rewarding those who help themselves and others to be free.

pragma solidity 0.8.19;
interface IFreedomSwaps {
    function swapExactInputSingle(address tokenIn, address tokenOut, uint256 amountIn, uint24 poolFee, uint24 slippage) external returns (uint256 amountOut);
    function swapBaseCurrency(address tokenIn, address tokenOut, uint24 poolFee, uint24 slippage) external payable  returns (uint256 amountOut);
    function getAmountOutMin(uint256 amountIn, uint256 price, uint256 slippage) external pure returns(uint256);
    function getPrice(address token0, address token1, uint24 poolFee) external view returns(uint256);
    function getSqrtPriceX96FromPool(address token0, address token1, uint24 fee) external view returns(uint256);
    function getAmount0(uint256 liquidity, uint256 sqrtPriceX96) external  pure returns(uint256);
    function getAmount1(uint256 liquidity, uint256 sqrtPriceX96) external pure returns(uint256);
    function getPriceFromAmounts(uint256 t0Decimals, uint256 t1Decimals, address t0, uint256 amount0, uint256 amount1, address asset) external pure returns(uint256);
    function getLiquidityFromPool(address token0, address token1, uint24 fee) external view returns(uint256);
}

// File: cost-average-into-freedom.sol



// We fund freedom.
// We stop state criminals.
// We make crypto cypherpunk again.
// We love Geo Caching with Geo Cash.
// We foster Freedom, Justice and Peace.
// We combine Crypto Education with Geo Caching.
// We foster sustainable liquidity infrastructures.
// We separate money from state criminals like religion has been separated from state.
// We foster ever emerging architectures of freedom by rewarding those who help themselves and others to be free.


pragma solidity 0.8.19;





contract CostAverageIntoFreedom {

    address private constant MATIC          = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address private constant FREEDOMSWAPS   = 0xA70f5023801F06A6a4C04695E794cf6e2ecCb34F;
    address private constant SWAP_ROUTER    = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    mapping(address => IDeposit) public deposits;

    struct IDeposit {
        uint256 input; // contains the amount of Matic deposited 
        address token; // e.g. 0xb841A4f979F9510760ecf60512e038656E68f459 
        uint256 swapped; // contains the total amount of Matic already swapped 
        uint256 interval; // e.g. 36000 (assuming a block-time of 2 seconds this would be around 5 hours)
        uint256 lastPurchase; // block number at last purchase or initial
        uint256 perPurchaseAmount; // defines how much Matic goes into each purchase
        uint256 claimable; // represents the amount the Freedom Lover can claim
    }

    ISwapRouter public immutable swapRouter;

    error Wait();
    error CheckInput();
    error DepositAlreadySwapped();

    constructor() {
        swapRouter = ISwapRouter(SWAP_ROUTER);
    }

    function deposit(uint256 interval, uint256 perPurchaseAmount, address token) public payable {
        if ((msg.value % perPurchaseAmount) != 0) { revert CheckInput(); }
        if (deposits[msg.sender].input == 0) {
            deposits[msg.sender] = IDeposit(msg.value, token, 0, interval, 0, perPurchaseAmount, 0);
        } else if(token == deposits[msg.sender].token) {
            deposits[msg.sender].input += msg.value;
            deposits[msg.sender].interval = interval;
            deposits[msg.sender].perPurchaseAmount = perPurchaseAmount;
        } else {
            revert CheckInput();
        }
    }

    function trigger(uint24 poolFee, uint24 slippage) public {
        if (deposits[msg.sender].input >= deposits[msg.sender].swapped + deposits[msg.sender].perPurchaseAmount) {
            if (block.number > deposits[msg.sender].lastPurchase + deposits[msg.sender].interval) {
                IFreedomSwaps(FREEDOMSWAPS).swapBaseCurrency{value: deposits[msg.sender].perPurchaseAmount}(MATIC, deposits[msg.sender].token, poolFee, slippage);
                deposits[msg.sender].lastPurchase = block.number;
                deposits[msg.sender].swapped += deposits[msg.sender].perPurchaseAmount;
            } else {
                revert Wait();
            }
        } else {
            revert DepositAlreadySwapped();
        }
    }

    function claim() public {
        if (deposits[msg.sender].claimable == 0) { revert CheckInput(); }
        IERC20(deposits[msg.sender].token).transferFrom(address(this), msg.sender, deposits[msg.sender].claimable);        
        deposits[msg.sender].claimable = 0;
    }
}
