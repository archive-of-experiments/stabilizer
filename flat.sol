
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

    uint256 public depositsCounter = 0;

    mapping(uint256 => IDeposit) public deposits; 
    
    mapping(address => uint256[]) depositIDs; 

    struct IDeposit {
        address from; // msg.sender of deposit
        uint256 input; // contains the amount of Matic deposited 
        address token; // e.g. 0xb841A4f979F9510760ecf60512e038656E68f459 
        uint256 swapped; // contains the total amount of Matic already swapped 
        uint256 minInterval; // e.g. 36000 (assuming a block-time of 2 seconds this would be around 5 hours)
        uint256 lastPurchase; // block number at last purchase or initial
        address payable[] recipients; // the beneficiaries 
        uint256 perPurchasePerRecipientAmount; // defines how much Matic goes into each purchase per recipient
    }

    error Wait();
    error CheckInput();
    error DepositAlreadySwapped();

    function deposit(uint256 minInterval, uint256 perPurchasePerRecipientAmount, address token, address payable[] memory recipients) public payable {
        if (msg.value % recipients.length != 0) { revert CheckInput(); }
        deposits[depositsCounter] = IDeposit(msg.sender, msg.value, token, 0, minInterval, 0, recipients, perPurchasePerRecipientAmount);
        depositIDs[msg.sender].push(depositsCounter);
        depositsCounter++;
    }

    function trigger(uint256 depositID, uint24 poolFee, uint24 slippage) public {
        if (deposits[depositID].from != msg.sender) { revert CheckInput(); }
        if (deposits[depositID].input > deposits[depositID].swapped) {
            if (block.number > deposits[depositID].lastPurchase + deposits[depositID].minInterval) {
                for (uint256 i = 0; i < deposits[depositID].recipients.length; i++) {
                    IFreedomSwaps(FREEDOMSWAPS).swapBaseCurrency{value: deposits[depositID].perPurchasePerRecipientAmount}(MATIC, deposits[depositID].token, deposits[depositID].recipients[i], poolFee, slippage);
                }
                deposits[depositID].lastPurchase = block.number;
                deposits[depositID].swapped += deposits[depositID].perPurchasePerRecipientAmount * deposits[depositID].recipients.length;
            } else {
                revert Wait();
            }
        } else {
            revert DepositAlreadySwapped();
        }
    }

    function getDepositIDs() public view returns(uint256[] memory) {
        return depositIDs[msg.sender];
    }
}
