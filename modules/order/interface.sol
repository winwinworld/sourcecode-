pragma solidity >=0.5.1 <0.7.0;

interface OrderInterface {

    // 
    event Log_HelpTo(address indexed owner, OrderInterface indexed order, uint amount, uint time);

    // 
    event Log_HelpGet(address indexed other, OrderInterface indexed order, uint amount, uint time);

    // 
    enum OrderType {
        // 
        PHGH,
        // ，
        OnlyPH,
        // ，，
        OnlyGH,
        // ，
        Linked
    }

    enum OrderStates {
        // 0:
        Unknown,
        // 1:
        Created,
        // 2:
        PaymentPart,
        // 3:
        PaymentCountDown,
        // 4:
        TearUp,
        // 5:,
        Frozen,
        // 6:
        Profiting,
        // 7:
        Done
    }

    enum TimeType {
        // 0.（)
        OnCreated,
        // 1.
        OnPaymentFrist,
        // 2.
        OnPaymentSuccess,
        // 3.
        OnProfitingBegin,
        // 4.
        OnCountDownStart,
        // 5.
        OnCountDownEnd,
        // 6.
        OnConvertConsumer,
        // 7.
        OnUnfreezing,
        // 8.
        OnDone
    }

    enum ConvertConsumerError {
        // 0: 
        Unkown,
        // 1: 
        NoError,
        // 2: （）Frozen
        NotFrozenState,
        // 3: 
        LessMinFrozen,
        // 4: ，
        NextOrderInvaild,
        // 5: 
        IsBreaker,
        // 6: ，，，
        IsFinalStateOrder
    }

    /////////////////////////////////////////////////////////////////////////////
    //                               View Functions                           //
    /////////////////////////////////////////////////////////////////////////////
    // 
    function times(uint8) external view returns (uint);

    // 
    function totalAmount() external view returns (uint);

    // 
    function toHelpedAmount() external view returns (uint);

    // 
    function getHelpedAmount() external view returns (uint);

    // 
    function getHelpedAmountTotal() external view returns (uint);

    // 
    function paymentPartMinLimit() external view returns (uint);

    // 
    function orderState() external view returns (OrderStates state);

    // 
    function contractOwner() external view returns (address);

    // 
    function orderIndex() external view returns (uint);

    // 
    function orderType() external view returns (OrderType);

    // 
    function blockRange(uint t) external view returns (uint);

    /////////////////////////////////////////////////////////////////////////////
    //                            Readonly Functions                           //
    /////////////////////////////////////////////////////////////////////////////

    // 
    function CurrentProfitInfo() external returns (OrderInterface.ConvertConsumerError, uint, uint);

    /////////////////////////////////////////////////////////////////////////////
    //                            ReadWrite Functions                          //
    /////////////////////////////////////////////////////////////////////////////
    // 
    function ApplyProfitingCountDown() external returns (bool canApply, bool applyResult);

    // ， CurrentProfitInfo code = 1 
    function DoConvertToConsumer() external returns (bool);

    // 
    function UpdateTimes(uint target) external;

    // ，
    function PaymentStateCheck() external returns (OrderStates state);

    // 
    function OrderStateCheck() external returns (OrderStates state);

    // 
    function CTL_GetHelpDelegate(OrderInterface helper, uint amount) external;

    // USDT,Controller
    function CTL_ToHelp(OrderInterface who, uint amount) external returns (bool);

    // 
    function CTL_SetNextOrderVaild() external;

    function CTL_ResoleveOrder(address newOwner) external;
}
