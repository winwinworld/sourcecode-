pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract PhoenixImpl is PhoenixState {
    modifier ControllerOnly {
        require(_CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    function GetInoutTotalInfo(address owner)
        external
        returns (uint256 totalIn, uint256 totalOut)
    {
        return (
            inoutMapping[dataStateVersion][owner].totalIn,
            inoutMapping[dataStateVersion][owner].totalOut
        );
    }

    function WithdrawCurrentRelaseCompensate()
        external
        returns (uint256 amount)
    {
        Compensate storage c = compensateMapping[msg.sender];
        if (c.total == 0 || c.currentWithdraw >= c.total) {
            return 0;
        }

        // 
        uint256 deltaDay = (now - c.latestWithdrawTime) / 1 days;
        if (deltaDay > 0) {
            amount = ((c.total * compensateRelaseProp) / 1 szabo) * deltaDay;
        }

        if ((amount + c.currentWithdraw) > c.total) {
            amount = c.total - c.currentWithdraw;
        }

        if (amount > 0) {
            c.currentWithdraw += amount;
            c.latestWithdrawTime = now;

            /// 
            pttInterface.operatorSend(
                address(pttInterface),
                msg.sender,
                amount,
                "WithdrawCompensate",
                ""
            );

            emit Log_CompensateRelase(msg.sender, now, amount);
        }
    }

    /// controller
    function CTL_SettlementCompensate(address owner)
        external
        ControllerOnly
        returns (uint256 total)
    {
        // 
        for (uint256 i = 0; i <= dataStateVersion; i++) {
            InoutTotal storage info = inoutMapping[i][owner];

            // 
            if (info.totalOut < info.totalIn) {
                if (compensateProp != 0) {
                    total += (info.totalIn - info.totalOut) * compensateProp;
                } else {
                    (, , , uint256 prop) = swapState.swapInfo();
                    total += (info.totalIn - info.totalOut) * prop;
                }
            }

            info.totalOut = 0;
            info.totalIn = 0;
        }

        // 
        if (total > 0) {
            Compensate storage c = compensateMapping[owner];
            c.total += total;

            if (c.latestWithdrawTime == 0) {
                c.latestWithdrawTime = now;
            }

            emit Log_CompensateCreated(owner, now, total);
        }
    }

    function CTL_AppendAmountInfo(
        address owner,
        uint256 inAmount,
        uint256 outAmount
    ) external ControllerOnly {
        inoutMapping[dataStateVersion][owner].totalIn += inAmount;
        inoutMapping[dataStateVersion][owner].totalOut += outAmount;
    }

    function CTL_ClearHistoryDelegate(address breaker) external ControllerOnly {
        inoutMapping[dataStateVersion][breaker] = InoutTotal(0, 0);
    }

    function ASTPoolAward_PushNewStateVersion() external {
        require(msg.sender == address(_ASTPoolAwards));
        dataStateVersion++;
    }

    // 
    function SetCompensateRelaseProp(uint256 p) external KOwnerOnly {
        compensateRelaseProp = p;
    }

    // 
    function SetCompensateProp(uint256 p) external KOwnerOnly {
        compensateProp = p;
    }
}
