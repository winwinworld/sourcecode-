pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

contract ControllerDelegateImpl is ControllerImpl {
    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    modifier RejectBreaker() {
        require(blackList[msg.sender] == false);
        _;
    }

    modifier OnlyOrders {
        require(_orderManager.isExistOrder(OrderInterface(msg.sender)));
        _;
    }

    function _tryToStopCountDown() internal {
        OrderInterface currConsumer = _orderManager.currentConsumer();
        /* if ( currConsumer == OrderInterface(0x0) || now - currConsumer.times(uint8(OrderInterface.TimeType.OnConvertConsumer)) < 24 hours ) { */
        if (currConsumer == OrderInterface(0x0)) {
            astAwardInterface.CTL_CountDownStop();
        }
    }

    // ，
    // 
    function order_PushProducerDelegate() external OnlyOrders {
        _orderManager.pushProducer(OrderInterface(msg.sender));
        _orderManager.getAndToHelp();
        _tryToStopCountDown();
    }

    // Profiting，，
    function order_PushConsumerDelegate()
        external
        OnlyOrders
        returns (uint256)
    {
        OrderInterface order = OrderInterface(msg.sender);

        address orderOwner = order.contractOwner();
        _orderManager.pushConsumer(order);
        _orderManager.getAndToHelp();
        _tryToStopCountDown();

        if (order.orderType() == OrderInterface.OrderType.PHGH) {
            /// ，
            /* require( createdOrderMapping[orderOwner][now / 1 days * 1 days] );
            createdOrderMapping[orderOwner][now / 1 days * 1 days] = false; */

            // 
            uint256 cost =
                ((order.getHelpedAmountTotal() *
                    configInterface.WithdrawCostProp()) / 1 szabo) *
                    configInterface.USDTToDTProp();

            pttInterface.operatorBurn(
                order.contractOwner(),
                cost,
                "ConvertBurn",
                ""
            );

            return cost;
        }

        return 0;
    }

    // ，，order，
    // 。rewardInterfaceController，Order
    // rewardInterface，
    function order_HandleAwardsDelegate(
        address addr,
        uint256 award,
        CounterModulesInterface.AwardType atype
    ) external OnlyOrders {
        if (award <= 0) {
            return;
        }

        // order，，
        if (_orderManager.ordersOf(addr).isNotEmpty()) {
            uint256 addrLatestOrderTotal =
                _orderManager.ordersOf(addr).latest().totalAmount();
            uint256 senderOrderTotal = OrderInterface(msg.sender).totalAmount();

            // ，0，
            if (senderOrderTotal <= 0) {
                return;
            }

            // 5000u,
            if (
                addrLatestOrderTotal >= senderOrderTotal ||
                addrLatestOrderTotal >= 3000e18
            ) {
                return rewardInterface.CTL_AddReward(addr, award, atype);
            } else {
                return
                    rewardInterface.CTL_AddReward(
                        addr,
                        (award * addrLatestOrderTotal) / senderOrderTotal,
                        atype
                    );
            }
        }
    }

    // 
    function order_PushBreakerToBlackList(address breakerAddress)
        external
        OnlyOrders
    {
        blackList[breakerAddress] = true;
    }

    // ，
    function order_DepositedAmountDelegate() external OnlyOrders {
        astAwardInterface.CTL_InvestQueueAppend(OrderInterface(msg.sender));
    }

    // 
    function order_ApplyProfitingCountDown()
        external
        OnlyOrders
        returns (bool)
    {
        return astAwardInterface.CTL_CountDownApplyBegin();
    }

    // InoutTotal
    function order_AppendTotalAmountInfo(
        address owner,
        uint256 inAmount,
        uint256 outAmount
    ) external OnlyOrders {
        phoenixInterface.CTL_AppendAmountInfo(owner, inAmount, outAmount);
    }

    function order_IsVaild(address order) external returns (bool) {
        return _orderManager.isExistOrder(OrderInterface(order));
    }
}
