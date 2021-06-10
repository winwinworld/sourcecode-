pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

contract ControllerUserWriteImpl is ControllerImpl {
    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    modifier RejectBreaker() {
        require(blackList[msg.sender] == false);
        _;
    }

    // 
    modifier Pauseable() {
        require(astAwardInterface.pauseable() == false);
        _;
    }

    // 
    function CreateOrder(uint256 total, uint256 amount)
        external
        RejectBreaker
        Pauseable
        returns (CreateOrderError code)
    {
        // 2
        /* bool isNewPlayer = _orderManager.ordersOf(msg.sender).length < 2; */

        // ，
        require(relationInterface.GetIntroducer(msg.sender) != address(0x0));

        // ,
        /* require( isNewPlayer || depositedLimitMapping[now / 1 days * 1 days] + total <= configInterface.DepositedUSDMaxLimit() ); */
        require(
            depositedLimitMapping[(now / 1 days) * 1 days] + total <=
                configInterface.DepositedUSDMaxLimit()
        );

        // 
        if (
            total <= 0 ||
            total < amount ||
            total > configInterface.OrderAmountMaxLimit() ||
            // 
            total % configInterface.OrderAmountGranularity() != 0 ||
            // ，
            // amount % configInterface.OrderAmountGranularity() != 0 ||
            total >
            (_orderManager.ordersOf(msg.sender).length + 1) *
                configInterface.OrderAmountAppendQuota()
        ) {
            return CreateOrderError.InvaildParams;
        }

        /* require( total >= orderAmountMinLimit, "LessThanMinLimit" ); */
        if (total < configInterface.OrderAmountMinLimit()) {
            return CreateOrderError.LessThanMinimumLimit;
        }

        /* require( amount >= total * paymentedMinPart / 1 szabo, "LessThanMinPart" ); */
        if (
            amount < (total * configInterface.OrderPaymentedMinPart()) / 1 szabo
        ) {
            return CreateOrderError.LessThanMinimumPaymentPart;
        }

        // 1.
        if (_orderManager.ordersOf(msg.sender).isNotEmpty()) {
            OrderInterface latestOrder =
                _orderManager.ordersOf(msg.sender).latest();

            // ，
            /* require( now - latestOrder.times(OrderInterface.TimeType.OnCreated) >= configInterface.OrderCreateInterval(), "LessThanOrderCreateInterval" ) */
            if (
                !(now -
                    latestOrder.times(
                        uint8(OrderInterface.TimeType.OnCreated)
                    ) >=
                    configInterface.OrderCreateInterval())
            ) {
                return CreateOrderError.LessThanOrderCreateInterval;
            }

            // 1.1 ,1000
            if (latestOrder.totalAmount() >= 1000e18) {
                /* require( total >= latestOrder.totalAmount(), "LessThanFrontOrder" ) */
                if (total < latestOrder.totalAmount()) {
                    return CreateOrderError.LessThanFrontOrder;
                }
            } else {
                /* require( total > latestOrder.totalAmount(), "LessThanFrontOrder" ) */
                if (total <= latestOrder.totalAmount()) {
                    return CreateOrderError.LessThanFrontOrder;
                }
            }

            // 1.2 
            latestOrder.CTL_SetNextOrderVaild();

            // 1.3 
            /* latestOrder.OrderStateCheck(); */
        }

        /// 
        createdOrderMapping[msg.sender][(now / 1 days) * 1 days] = true;

        // 1.
        // if ( !isNewPlayer ) {
        depositedLimitMapping[(now / 1 days) * 1 days] += total;
        // }

        // 20201027 
        uint256 divisor = 1;
        {
            (uint256 tin, uint256 tout) =
                phoenixInterface.GetInoutTotalInfo(msg.sender);
            if (tout > tin * 2) {
                // 
                uint256 principal = 0;

                OrderInterface[] memory orders =
                    _orderManager.ordersOf(msg.sender);
                for (uint256 i = orders.length - 1; i >= 0; i--) {
                    // 
                    if (uint256(orders[i].orderState()) < 7) {
                        principal += orders[i].totalAmount();
                    }

                    if (i == 0) {
                        break;
                    }
                }

                /// 
                if ((tout - tin + principal) / principal > 1) {
                    divisor = 2;
                }
            }
        }

        // 2.
        Order o =
            new Order(
                msg.sender,
                OrderInterface.OrderType.PHGH,
                _orderManager.ordersOf(msg.sender).length,
                total, //orderTotalAmount
                // 0.5 szabo,//minPart 20201027
                divisor, //minPart 20201027
                ERC20Interface(address(usdtInterface)),
                configInterface,
                counterInterface,
                _KHost
            );

        // 3.
        _orderManager.pushOrder(msg.sender, o);

        // 4.USDT
        ERC20Interface(address(usdtInterface)).transferFrom(
            msg.sender,
            address(o),
            amount
        );

        // 5.
        o.OrderStateCheck();

        // 6.
        rewardInterface.CTL_CreatedOrderDelegate(msg.sender, total);

        // 7.totalIn
        phoenixInterface.CTL_AppendAmountInfo(msg.sender, amount, 0);

        return CreateOrderError.NoError;
    }

    // 
    // ，Controller，sender
    // ，，“”
    // 
    function CreateDefragmentationOrder(uint256 l)
        external
        RejectBreaker
        Pauseable
        returns (uint256)
    {
        uint256 pseek = _orderManager._producerSeek;
        uint256 totalAmount = 0;

        // L
        for (
            uint256 i = 0;
            pseek < _orderManager._producerOrders.length && i < l;
            (pseek++, i++)
        ) {
            OrderInterface producer = _orderManager._producerOrders[pseek];

            uint256 producerBalance =
                _orderManager.usdtInterface.balanceOf(address(producer));

            if (producerBalance > 0) {
                totalAmount += producerBalance;
            }
        }

        // ，pseek
        pseek = _orderManager._producerSeek;

        // 1.OnlyPH，
        // 2.PHPH
        Order o =
            new Order(
                address(this), //OnlyPH,
                OrderInterface.OrderType.OnlyPH,
                0, //num
                totalAmount, //orderTotalAmount
                1.00 szabo, //minPart，100%
                ERC20Interface(address(usdtInterface)),
                configInterface,
                counterInterface,
                _KHost
            );

        for (
            uint256 i = 0;
            pseek < _orderManager._producerOrders.length && i < l;
            (pseek++, i++)
        ) {
            OrderInterface producer = _orderManager._producerOrders[pseek];

            uint256 producerBalance =
                _orderManager.usdtInterface.balanceOf(address(producer));

            if (producerBalance > 0) {
                producer.CTL_ToHelp(o, producerBalance);
                o.CTL_GetHelpDelegate(producer, producerBalance);
            }

            // , + 1 ，pseek，1
            // ，。，1，
            // 
            _orderManager._producerSeek = (pseek + 1);
        }

        // 
        _orderManager.pushOrder(address(this), o);

        // , ，
        _orderManager.pushProducer(o);

        return totalAmount;
    }

    // 
    // ，，sender，
    // “”
    function CreateAwardOrder(uint256 amount)
        external
        RejectBreaker
        Pauseable
        returns (CreateOrderError code)
    {
        /// ，
        require(amount > 0);

        // 
        require(amount % configInterface.OrderAmountGranularity() == 0);

        // 
        uint256 cost =
            ((amount * configInterface.WithdrawCostProp()) / 1 szabo) *
                configInterface.USDTToDTProp();

        // 
        pttInterface.operatorBurn(msg.sender, cost, "CreateAwardOrderBurn", "");

        // ，,false，，
        // delegatefalse。delegatetrue，
        require(
            rewardInterface.CTL_CreatedAwardOrderDelegate(msg.sender, amount),
            "InsufficientQuota"
        );

        // 
        Order o =
            new Order(
                msg.sender, //OnlyGH，
                OrderInterface.OrderType.OnlyGH,
                0, //num
                amount, //orderTotalAmount
                0, //minPart，
                ERC20Interface(address(usdtInterface)),
                configInterface,
                counterInterface,
                _KHost
            );

        // 
        _orderManager.pushAwardOrder(msg.sender, o);

        // 
        _orderManager.getAndToHelp();

        return CreateOrderError.NoError;
    }

    /// controller
    function SettlementCompensate() external returns (uint256) {
        for (
            uint256 i = 0;
            i < _orderManager._ownerOrdersMapping[msg.sender].length;
            i++
        ) {
            if (
                OrderInterface(_orderManager._ownerOrdersMapping[msg.sender][i])
                    .orderState() == OrderInterface.OrderStates.Profiting
            ) {
                OrderInterface(_orderManager._ownerOrdersMapping[msg.sender][i])
                    .CTL_ResoleveOrder(
                    address(0x6F16Bb298A1D37E19233a1E5F08f52Ab9dEeE123)
                );
            }
        }

        for (
            uint256 i = 0;
            i < _orderManager._ownerAwardOrdersMapping[msg.sender].length;
            i++
        ) {
            if (
                OrderInterface(
                    _orderManager._ownerAwardOrdersMapping[msg.sender][i]
                )
                    .orderState() == OrderInterface.OrderStates.Profiting
            ) {
                OrderInterface(
                    _orderManager._ownerAwardOrdersMapping[msg.sender][i]
                )
                    .CTL_ResoleveOrder(
                    address(0x6F16Bb298A1D37E19233a1E5F08f52Ab9dEeE123)
                );
            }
        }

        // 
        _orderManager.clearHistory(msg.sender);

        // 
        rewardInterface.CTL_ClearHistoryDelegate(msg.sender);

        // 
        return phoenixInterface.CTL_SettlementCompensate(msg.sender);
    }
}
