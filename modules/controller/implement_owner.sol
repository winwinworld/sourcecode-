pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

contract ControllerOwnerImpl is ControllerImpl {

    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    /////////////////////////////////////////////////////////////////////////////
    //                             Dapp Functions                              //
    /////////////////////////////////////////////////////////////////////////////
    // 
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
        // [0]: 
        // [1]: 
        // [2]: 
        uint96[] memory times
    ) {
        OrderInterface[] memory source;

        // 
        if ( orderType == OrderInterface.OrderType.PHGH ) {
            source = _orderManager.ordersOf(owner);
        } else if ( orderType == OrderInterface.OrderType.OnlyGH ) {
            source = _orderManager.awardOrdersOf(owner);
        } else if ( orderType == OrderInterface.OrderType.OnlyPH ) {
            source = _orderManager.ordersOf(address(this));
        } else {
            source = _orderManager.ordersOf(owner);
        }

        // offset，,
        require( offset < source.length );

        // state
        // OrderStates 
        // OrderStates.Unknown              0b00000000
        // OrderStates.Created              0b00000001
        // OrderStates.PaymentPart          0b00000010
        // OrderStates.PaymentCountDown     0b00000100 ()
        // OrderStates.TearUp               0b00001000
        // OrderStates.Frozen               0b00010000
        // OrderStates.Profiting            0b00100000
        // OrderStates.Done                 0b01000000
        // OrderStates.AllState             0b11111111 //
        // 
        for ( uint i = 0; i < source.length; i++ ) {
            if ( uint(source[i].orderState()) <= 0 ) {
                continue;
            }

            // 
            uint bcode = 1 << (uint(source[i].orderState()) - 1);
            if ( orderState & bcode == bcode  ) {
                ++total;
            }
        }

        // 
        if ( offset + size > source.length - 1 ) {
            len = source.length - offset;
        } else {
            len = size;
        }

        // 
        orders = new OrderInterface[](len);
        totalAmounts = new uint[](len);
        states = new OrderInterface.OrderStates[](len);
        times = new uint96[](len);

        for (
            (uint s, uint i) = (0, offset);
            i < offset + len;
            (s++, i++)
        ) {
            if ( uint(source[i].orderState()) <= 0 ) {
                continue;
            }

            // 
            uint bcode = 1 << (uint(source[i].orderState()) - 1);
            if ( orderState & bcode == bcode  ) {
                orders[s] = source[i];
                totalAmounts[s] = source[i].totalAmount();
                states[s] = source[i].orderState();

                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnCreated))) << 64);
                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnCountDownStart))) << 32);
                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnUnfreezing))));
            }
        }
    }

    function OwnerGetSeekInfo() external KOwnerOnly returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek) {
        return (
            _orderManager._orders.length,//total
            _orderManager._producerOrders.length,//ptotal
            _orderManager._consumerOrders.length,//ctotal
            _orderManager._producerSeek,//pseek
            _orderManager._consumerSeek//cseek
        );
    }

    // 
    function OwnerGetOrder(QueueName qname, uint seek) external KOwnerOnly returns (OrderInterface) {
        if ( qname == QueueName.Producer ) {
            return _orderManager._producerOrders[seek];
        } else if ( qname == QueueName.Consumer ) {
            return _orderManager._consumerOrders[seek];
        } else if ( qname == QueueName.Main ) {
            return _orderManager._orders[seek];
        }
        return OrderInterface(0x0);
    }

    // 
    function OwnerGetOrderList(QueueName qname, uint offset, uint size) external KOwnerOnly
    returns (
        // 
        OrderInterface[] memory orders,
        // 
        uint[] memory times,
        // 
        uint[] memory totalAmounts
    ) {
        OrderInterface[] storage source = _orderManager._orders;

        // 
        if ( qname == QueueName.Producer ) {
            source = _orderManager._producerOrders;
        } else if ( qname == QueueName.Consumer ) {
            source = _orderManager._consumerOrders;
        }

        orders = new OrderInterface[](size);
        times = new uint[](size);
        totalAmounts = new uint[](size);

        for (
            (uint i, uint j) = (0, offset);
            j < offset + size && j < source.length;
            (j++, i++)
        ) {
            orders[i] = source[j];
            totalAmounts[i] = source[j].totalAmount();
            times[i] = source[j].times( uint8(OrderInterface.TimeType.OnCountDownStart));
        }
    }

    // ()
    function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external KOwnerOnly {
        for (uint i = 0; i < orders.length; i++) {
            orders[i].UpdateTimes(targetTimes);
        }
    }

    /// ，
    function ForceGetAndToHelp() external KOwnerOnly {
        _orderManager.getAndToHelp();
    }
}
