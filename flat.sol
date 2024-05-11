
// File: https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v1.0.0/IFreedomSwaps.sol



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
    function swapExactInputSingle(address tokenIn, address tokenOut, address payable recipient, uint256 amountIn, uint24 poolFee, uint24 slippage) external returns (uint256 amountOut);
    function swapBaseCurrency(address tokenIn, address tokenOut, address payable recipient, uint24 poolFee, uint24 slippage) external payable returns (uint256 amountOut);
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
    address private constant FREEDOMSWAPS   = 0x06b80F66A1A72a9C36FB0298EE1B22406e377d0e;
    address private constant SWAP_ROUTER    = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    mapping(address => IDeposit) public deposits;
    struct IDeposit {
        uint256 input; // contains the amount of Matic deposited 
        address token; // e.g. 0xb841A4f979F9510760ecf60512e038656E68f459 
        uint256 swapped; // contains the total amount of Matic already swapped 
        uint256 minInterval; // e.g. 36000 (assuming a block-time of 2 seconds this would be around 5 hours)
        uint256 lastPurchase; // block number at last purchase or initial
        uint256 perPurchaseAmount; // defines how much Matic goes into each purchase
        address payable recipient; // the beneficiary
    }

    error Wait();
    error CheckInput();
    error DepositAlreadySwapped();

    function deposit(uint256 minInterval, uint256 perPurchaseAmount, address token, address payable recipient) public payable {
        if ((msg.value % perPurchaseAmount) != 0) { revert CheckInput(); }
        if (deposits[msg.sender].input - deposits[msg.sender].swapped == 0) {
            deposits[msg.sender] = IDeposit(msg.value, token, 0, minInterval, 0, perPurchaseAmount, recipient);
        } else if(token == deposits[msg.sender].token) {
            deposits[msg.sender].input += msg.value;
            deposits[msg.sender].minInterval = minInterval;
            deposits[msg.sender].perPurchaseAmount = perPurchaseAmount;
        } else {
            revert CheckInput();
        }
    }

    function trigger(uint24 poolFee, uint24 slippage) public {
        if (deposits[msg.sender].input >= deposits[msg.sender].swapped + deposits[msg.sender].perPurchaseAmount) {
            if (block.number > deposits[msg.sender].lastPurchase + deposits[msg.sender].minInterval) {
                IFreedomSwaps(FREEDOMSWAPS).swapBaseCurrency{value: deposits[msg.sender].perPurchaseAmount}(MATIC, deposits[msg.sender].token, deposits[msg.sender].recipient, poolFee, slippage);
                deposits[msg.sender].lastPurchase = block.number;
                deposits[msg.sender].swapped += deposits[msg.sender].perPurchaseAmount;
            } else {
                revert Wait();
            }
        } else {
            revert DepositAlreadySwapped();
        }
    }
}
