pragma solidity >=0.5.1 <0.7.0;

import "../order/interface.sol";
import "../counter/interface.sol";

//  interface
interface ControllerInterface_User_Write {

    enum CreateOrderError {
        // 0: 
        NoError,
        // 1: 
        LessThanMinimumLimit,
        // 2: 
        LessThanMinimumPaymentPart,
        // 3: 1000，
        LessThanFrontOrder,
        // 4: 
        LessThanOrderCreateInterval,
        // 5: 
        InvaildParams,
        // 6: 
        CostInsufficient
    }

    // 
    function CreateOrder(uint total, uint amount) external returns (CreateOrderError code);

    // 
    // ，，sender，
    // “”
    function CreateAwardOrder(uint amount) external returns (CreateOrderError code);

    // ，，
    function CreateDefragmentationOrder(uint l) external returns (uint totalAmount);

    /// controller
    function SettlementCompensate() external returns (uint);
}

//  interface
interface ControllerInterface_User_Read {

    // 
    function IsBreaker(address owner) external returns (bool);

    // 
    function ResolveBreaker() external;

    // 
    function GetOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);

    // （OnlyGH)
    function GetAwardOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
}

interface ControllerDelegate {

    // 
    function order_PushProducerDelegate() external;

    // 
    function order_PushConsumerDelegate() external returns (uint);

    // 
    function order_HandleAwardsDelegate(address addr, uint award, CounterModulesInterface.AwardType atype ) external;

    // 
    function order_PushBreakerToBlackList(address breakerAddress) external;

    // ，，
    function order_DepositedAmountDelegate() external;

    // 
    function order_ApplyProfitingCountDown() external returns (bool);

    // 
    function order_AppendTotalAmountInfo(address owner, uint inAmount, uint outAmount) external;

    // Controller
    function order_IsVaild(address orderAddress) external returns (bool);
}

interface ControllerInterface_Onwer {

    function QueryOrders(
        // 
        address owner,
        // 
        OrderInterface.OrderType orderType,
        // 
        uint orderState,
        // pageIndex
        uint offset,
        // pageSize
        uint size
    ) external returns (
        // 
        uint total,
        // 
        uint len,
        // 
        OrderInterface[] memory orders,
        // 
        uint[] memory totalAmounts,
        // 
        OrderInterface.OrderStates[] memory states,
        // 
        uint96[] memory times
    );

    /////////////////////////////////////////////////////////////////////////////
    //                              Owner Functions                            //
    /////////////////////////////////////////////////////////////////////////////
    // 
    // total  : 
    // ptotal : 
    // ctotal : 
    // pseek  : 
    // cseek  : 
    function OwnerGetSeekInfo() external returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek);

    // 
    enum QueueName {
        // 
        Producer,
        // 
        Consumer,
        // 
        Main
    }
    function OwnerGetOrder(QueueName qname, uint seek) external returns (OrderInterface);

    // 
    function OwnerGetOrderList(QueueName qname, uint offset, uint size) external
    returns (
        // 
        OrderInterface[] memory orders,
        // 
        uint[] memory times,
        // 
        uint[] memory totalAmounts
    );

    // 
    function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external;

    /// ，
    function ForceGetAndToHelp() external;
}


contract ControllerInterface is ControllerInterface_User_Write, ControllerInterface_User_Read, ControllerInterface_Onwer {}
