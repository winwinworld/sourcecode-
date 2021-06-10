pragma solidity >=0.5.1 <0.7.0;

interface ConfigInterface {

    enum Keys {
        // 0.，
        WaitTime,
        // 1.
        PaymentCountDownSec,
        // 2.
        ForzenTimesMin,
        // 3.
        ForzenTimesMax,
        // 4.P1
        ProfitPropP1,
        // 5.P2
        ProfitPropTotalP2,
        // 6.
        OrderCreateInterval,
        // 7.
        OrderAmountAppendQuota,
        // 8.(USDT mwei)
        OrderAmountMinLimit,
        // 9.(USDT mwei)
        OrderAmountMaxLimit,
        // 10. 0.5 szabo  50%
        OrderPaymentedMinPart,
        // 11.
        OrderAmountGranularity,
        // 12.USDT，DT
        WithdrawCostProp,
        // 13., 1 USDT : xx DT
        USDTToDTProp,
        // 14.
        DepositedUSDMaxLimit,
        // 15.DT
        ResolveBreakerDTAmount
    }

    function GetConfigValue(Keys k) external view returns (uint);
    function SetConfigValue(Keys k, uint v) external;

    // ，
    function WaitTime() external view returns (uint);

    // 
    function PaymentCountDownSec() external view returns (uint);

    // 
    function ForzenTimesMin() external view returns (uint);

    // 
    function ForzenTimesMax() external view returns (uint);

    // P1
    function ProfitPropP1() external view returns (uint);

    // P2
    function ProfitPropTotalP2() external view returns (uint);

    // 
    function OrderCreateInterval() external view returns (uint);

    // s
    function OrderAmountAppendQuota() external view returns (uint);

    // (USDT mwei)
    function OrderAmountMinLimit() external view returns (uint);

    // (USDT mwei)
    function OrderAmountMaxLimit() external view returns (uint);

    //  0.5 szabo  50%
    function OrderPaymentedMinPart() external view returns (uint);

    // 
    function OrderAmountGranularity() external view returns (uint);

    // USDT，DT
    function WithdrawCostProp() external view returns (uint);

    // , 1 USDT : xx DT
    function USDTToDTProp() external view returns (uint);

    // 
    function DepositedUSDMaxLimit() external view returns (uint);

    // DT
    function ResolveBreakerDTAmount() external view returns (uint);
}
