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
        uint256 input; // contains the total amount of Matic deposited 
        address token; // e.g. 0xb841A4f979F9510760ecf60512e038656E68f459 
        uint256 swapped; // contains the total amount of Matic already swapped 
        uint256 interval; // e.g. 36000 (assuming a block-time of 2 seconds this would be around 5 hours)
        uint256 lastPurchase; // block number at last purchase
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
        } else {
            deposits[msg.sender].input += msg.value;
            deposits[msg.sender].interval = interval;
            deposits[msg.sender].perPurchaseAmount = perPurchaseAmount;
        }
    }

    function claim() public {
        if (deposits[msg.sender].claimableGeld == 0) { revert CheckInput(); }
        IERC20(deposits[msg.sender].token).transferFrom(address(this), msg.sender, deposits[msg.sender].claimableGeld);        
        deposits[msg.sender].claimable = 0;
    }

    function trigger(uint24 poolFee, uint24 slippage) public {
        if (deposits[msg.sender].input >= deposits[msg.sender].swapped + deposits[msg.sender].perPurchaseAmount) {
            if (block.number > deposits[msg.sender].lastPurchase + deposits[msg.sender].interval) {
                IFreedomSwaps(FREEDOMSWAPS).swapBaseCurrency{value: deposits[msg.sender].perPurchaseAmount}(MATIC, GEOCASH, poolFee, slippage);
                deposits[msg.sender].lastPurchase = block.number;
                deposits[msg.sender].swapped += deposits[msg.sender].perPurchaseAmount;
            } else {
                revert Wait();
            }
        } else {
            revert DepositAlreadySwapped();
        }
    }

    function approve(uint256 amount) public {
        if (IERC20(MATIC).allowance(address(this), address(swapRouter)) < amount) {
            TransferHelper.safeApprove(MATIC, address(swapRouter), amount);
        }
    }

}
