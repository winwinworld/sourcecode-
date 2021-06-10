pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Order is OrderState, KContract {

    constructor(
        // 
        address owner,
        // 
        OrderType ortype,
        // 
        uint num,
        // 
        uint orderTotalAmount,
        // 
        uint minPart,
        // usdt
        ERC20Interface usdInc,
        // 
        ConfigInterface configInc,
        // 
        CounterModulesInterface counterInc,
        // khosts
        Hosts host
    ) public {

        _KHost = host;
        blockRange[0] = block.number;

        _usdtInterface = usdInc;
        _CTL = ControllerDelegate(msg.sender);
        _configInterface = configInc;
        _counterInteface = counterInc;

        contractOwner = owner;
        orderIndex = num;
        orderType = ortype;
        paymentPartMinLimit = minPart;
        orderState = OrderStates.Created;

        // 
        times[uint8(TimeType.OnCreated)] = now;

        if ( ortype == OrderType.PHGH ) {

            totalAmount = orderTotalAmount;

            // 
            times[uint8(TimeType.OnCountDownStart)] = now + configInc.WaitTime();
            // 
            times[uint8(TimeType.OnCountDownEnd)] = now + configInc.WaitTime() + configInc.PaymentCountDownSec();
            // 
            times[uint8(TimeType.OnProfitingBegin)] = now + configInc.WaitTime();
        }
        // OnlyPH ，，
        // ，，,，，
        // ，，
        // ，,
        // 。
        // ，
        // 
        else if ( ortype == OrderType.OnlyPH ) {
            totalAmount = orderTotalAmount;
            getHelpedAmountTotal = orderTotalAmount;

            // ，GetHelpDelegate
            // getHelpedAmount = orderTotalAmount

            // 0
            orderIndex = 0;
            orderState = OrderStates.Done;

            // ，，
            // ，OnlyPH， this
            contractOwner = address(this);
        }
        // OnlyGH，，PH
        // GH，Profiting，Profiting，Done
        // ，,
        else if ( ortype == OrderType.OnlyGH ) {
            totalAmount = 0;
            orderIndex = 0;
            getHelpedAmountTotal = orderTotalAmount;
            orderState = OrderStates.Profiting;
            times[uint8(TimeType.OnConvertConsumer)] = now;
            // ，getHelpedAmountTotal，
            // ，getHelpedAmountTotal。
        }
    }

    function ForzonPropEveryDay() external readonly returns (uint) {
        super.implementcall();
    }

    function CurrentProfitInfo() external readonly returns (OrderInterface.ConvertConsumerError, uint, uint) {
        super.implementcall();
    }

    function DoConvertToConsumer() external readwrite returns (bool) {
        super.implementcall();
    }

    function UpdateTimes(uint) external {
        super.implementcall();
    }

    function PaymentStateCheck() external readwrite returns (OrderStates) {
        super.implementcall();
    }

    function OrderStateCheck() external readwrite returns (OrderInterface.OrderStates) {
        super.implementcall();
    }

    function ApplyProfitingCountDown() external readwrite returns (bool, bool) {
        super.implementcall();
    }

    function CTL_SetNextOrderVaild() external readwrite {
        super.implementcall();
    }

    function CTL_GetHelpDelegate(OrderInterface, uint) external readwrite {
        super.implementcall();
    }

    function CTL_ToHelp(OrderInterface, uint) external readwrite returns (bool) {
        super.implementcall();
    }

    function CTL_ResoleveOrder(address) external readwrite {
        super.implementcall();
    }
}
