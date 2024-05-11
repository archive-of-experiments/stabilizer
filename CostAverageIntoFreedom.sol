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
import "https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v1.0.0/IFreedomSwaps.sol";

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
