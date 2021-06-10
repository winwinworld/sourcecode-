pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterManager is CounterManagerState, KContract {

    constructor(
        RelationshipInterface rltInc,
        ERC777Interface usdtInc,
        RewardInterface rewardInc,
        Hosts host
    ) public {
        RLTInterface = rltInc;
        usdtInterface = usdtInc;
        rewardInterface = rewardInc;
        _KHost = host;
    }

    // 
    function InitSet_AuthorizedAddress(address addr) external KOwnerOnly {
        authorizedAddress = addr;
    }

    // 
    function InfomationOf(address) external readonly returns (bool, uint, uint, uint) {
        super.implementcall();
    }

    // 
    function LevelListOf(uint) external readonly returns (address[] memory) {
        super.implementcall();
    }

    // 
    function UpgradeDLevel() external readwrite returns (uint, uint) {
        super.implementcall();
    }

    // D1
    function PaymentDLevel(uint) external readwrite returns (bool) {
        super.implementcall();
    }

    // ，，
    function WhenOrderCreatedDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    // ，,len，,
    function WhenOrderFrozenDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    // 
    function WhenOrderDoneDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    // 
    function SetRecommendAwardProp(uint, uint) external readwrite {
        super.implementcall();
    }

    // D
    function SetDLevelAwardProp(uint, uint) external readwrite {
        super.implementcall();
    }

    // D
    function SetDLevelSearchDepth(uint) external readwrite {
        super.implementcall();
    }

    // D1，
    function SetDlevel1DepositedNeed(uint) external readwrite {
        super.implementcall();
    }

    // D1DT
    function SetDLevelPrices(uint, uint) external readwrite {
        super.implementcall();
    }
}
