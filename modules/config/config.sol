pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "./interface.sol";

contract Config is ConfigInterface, KOwnerable {
    mapping(uint256 => uint256) public configMapping;

    constructor() public {
        // ，
        configMapping[uint256(Keys.WaitTime)] = 3 days;

        // 
        configMapping[uint256(Keys.PaymentCountDownSec)] = 72 hours;

        // 
        configMapping[uint256(Keys.ForzenTimesMin)] = 7 days;

        // 
        configMapping[uint256(Keys.ForzenTimesMax)] = 20 days;

        // P1
        configMapping[uint256(Keys.ProfitPropP1)] = 0.01 szabo;

        // P2
        configMapping[uint256(Keys.ProfitPropTotalP2)] = 0.1 szabo;

        // 
        configMapping[uint256(Keys.OrderCreateInterval)] = 5 days;

        // 
        configMapping[uint256(Keys.OrderAmountAppendQuota)] = 2000e18;

        // (USDT mwei)
        configMapping[uint256(Keys.OrderAmountMinLimit)] = 100e18;

        // (USDT mwei)
        configMapping[uint256(Keys.OrderAmountMaxLimit)] = 10000e18;

        // 
        configMapping[uint256(Keys.OrderAmountGranularity)] = 10e18;

        //  0.5 szabo  50%
        configMapping[uint256(Keys.OrderPaymentedMinPart)] = 0.6 szabo;

        // USDT，DT
        configMapping[uint256(Keys.WithdrawCostProp)] = 0.02 szabo;

        // , 1 USDT : 20 DT
        //      1e6(wei) : 20e18(wei)
        //    = 1e6 : 2e19
        //    = 1 : 2e13
        //    = 20e13
        configMapping[uint256(Keys.USDTToDTProp)] = 50;

        // 
        configMapping[uint256(Keys.DepositedUSDMaxLimit)] = 30000e18;

        // DT
        configMapping[uint256(Keys.ResolveBreakerDTAmount)] = 1000 ether;
    }

    function GetConfigValue(Keys k) external view returns (uint256) {
        return configMapping[uint256(k)];
    }

    function SetConfigValue(Keys k, uint256 v) external KOwnerOnly {
        configMapping[uint256(k)] = v;
    }

    // ，
    function WaitTime() external view returns (uint256) {
        return configMapping[uint256(Keys.WaitTime)];
    }

    // 
    function PaymentCountDownSec() external view returns (uint256) {
        return configMapping[uint256(Keys.PaymentCountDownSec)];
    }

    // 
    function ForzenTimesMin() external view returns (uint256) {
        return configMapping[uint256(Keys.ForzenTimesMin)];
    }

    // 
    function ForzenTimesMax() external view returns (uint256) {
        return configMapping[uint256(Keys.ForzenTimesMax)];
    }

    // P1
    function ProfitPropP1() external view returns (uint256) {
        return configMapping[uint256(Keys.ProfitPropP1)];
    }

    // P2
    function ProfitPropTotalP2() external view returns (uint256) {
        return configMapping[uint256(Keys.ProfitPropTotalP2)];
    }

    // 
    function OrderCreateInterval() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderCreateInterval)];
    }

    // 
    function OrderAmountAppendQuota() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderAmountAppendQuota)];
    }

    // (USDT mwei)
    function OrderAmountMinLimit() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderAmountMinLimit)];
    }

    // (USDT mwei)
    function OrderAmountMaxLimit() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderAmountMaxLimit)];
    }

    //  0.5 szabo  50%
    function OrderPaymentedMinPart() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderPaymentedMinPart)];
    }

    // 
    function OrderAmountGranularity() external view returns (uint256) {
        return configMapping[uint256(Keys.OrderAmountGranularity)];
    }

    // USDT，DT
    function WithdrawCostProp() external view returns (uint256) {
        return configMapping[uint256(Keys.WithdrawCostProp)];
    }

    // , 1 USDT : xx DT
    function USDTToDTProp() external view returns (uint256) {
        return configMapping[uint256(Keys.USDTToDTProp)];
    }

    // 
    function DepositedUSDMaxLimit() external view returns (uint256) {
        return configMapping[uint256(Keys.DepositedUSDMaxLimit)];
    }

    // DT
    function ResolveBreakerDTAmount() external view returns (uint256) {
        return configMapping[uint256(Keys.ResolveBreakerDTAmount)];
    }
}
