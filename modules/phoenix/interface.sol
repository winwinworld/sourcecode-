pragma solidity >=0.5.1 <0.7.0;

interface PhoenixInterface {
    struct InoutTotal {
        uint256 totalIn;
        uint256 totalOut;
    }

    struct Compensate {
        // 
        uint256 total;
        // 
        uint256 currentWithdraw;
        // 
        uint256 latestWithdrawTime;
    }

    // ,
    event Log_CompensateCreated(
        address indexed owner,
        uint256 when,
        uint256 compensateAmount
    );

    // 
    event Log_CompensateRelase(
        address indexed owner,
        uint256 when,
        uint256 relaseAmount
    );

    // 
    function GetInoutTotalInfo(address owner)
        external
        returns (uint256 totalIn, uint256 totalOut);

    // 
    function WithdrawCurrentRelaseCompensate()
        external
        returns (uint256 amount);

    // 
    function CTL_AppendAmountInfo(
        address owner,
        uint256 inAmount,
        uint256 outAmount
    ) external;

    // ，（）
    function CTL_ClearHistoryDelegate(address breaker) external;

    function CTL_SettlementCompensate(address owner)
        external
        returns (uint256 total);

    // ,ASTPoolAward
    function ASTPoolAward_PushNewStateVersion() external;

    // 
    function SetCompensateRelaseProp(uint256 p) external;

    // 
    function SetCompensateProp(uint256 p) external;
}
