// SPDX-License-Identifier: GNU AFFERO GENERAL PUBLIC LICENSE Version 3

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
import "https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v0.0.1/IFreedomSwaps.sol";
import "https://raw.githubusercontent.com/Uniswap/v3-periphery/main/contracts/interfaces/ISwapRouter.sol";
import "https://raw.githubusercontent.com/Uniswap/solidity-lib/master/contracts/libraries/TransferHelper.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.4/contracts/token/ERC20/IERC20.sol";


contract CostAverageIntoFreedom {

    address private constant MATIC          = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address private constant FREEDOMSWAPS   = 0xA70f5023801F06A6a4C04695E794cf6e2ecCb34F;
    address private constant SWAP_ROUTER    = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    mapping(address => IDeposit) public deposits;
    struct IDeposit {
        uint256 input; // contains the amount of Matic deposited 
        address token; // e.g. 0xb841A4f979F9510760ecf60512e038656E68f459 
        uint256 swapped; // contains the total amount of Matic already swapped 
        uint256 minInterval; // e.g. 36000 (assuming a block-time of 2 seconds this would be around 5 hours)
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

    function deposit(uint256 minInterval, uint256 perPurchaseAmount, address token) public payable {
        if ((msg.value % perPurchaseAmount) != 0) { revert CheckInput(); }
        if (deposits[msg.sender].input - deposits[msg.sender].swapped == 0 && deposits[msg.sender].claimable == 0) {
            deposits[msg.sender] = IDeposit(msg.value, token, 0, minInterval, 0, perPurchaseAmount, 0);
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
                uint256 amountOut = IFreedomSwaps(FREEDOMSWAPS).swapBaseCurrency{value: deposits[msg.sender].perPurchaseAmount}(MATIC, deposits[msg.sender].token, poolFee, slippage);
                deposits[msg.sender].lastPurchase = block.number;
                deposits[msg.sender].swapped += deposits[msg.sender].perPurchaseAmount;
                deposits[msg.sender].claimable += amountOut;
            } else {
                revert Wait();
            }
        } else {
            revert DepositAlreadySwapped();
        }
    }

    function claim() public {
        if (deposits[msg.sender].claimable == 0) { revert CheckInput(); }
        if (IERC20(MATIC).allowance(address(this), msg.sender) < deposits[msg.sender].claimable) {
            TransferHelper.safeApprove(deposits[msg.sender].token, msg.sender, deposits[msg.sender].claimable);
        }
        IERC20(deposits[msg.sender].token).transferFrom(address(this), msg.sender, deposits[msg.sender].claimable);        
        deposits[msg.sender].claimable = 0;
    }
}
