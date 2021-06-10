pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolAwards is AssertPoolAwardsState, KContract {

    constructor(
        AssertPoolInterface astPool,
        ERC777Interface usdtInc,
        Hosts host
    ) public {

        _KHost = host;
        apInterface = astPool;
        usdtInterface = usdtInc;

        // 
        // 
        // Desc 1 P:100 20%
        specialRewardsDescMapping[0] = 100;
        specialPropMaxlimitMapping[0] = 1.0 szabo;

        // Desc 2 P:10 10%
        specialRewardsDescMapping[1] = 10;
        specialPropMaxlimitMapping[1] = 1.0 szabo;

        // Desc 3 P:5 10%
        specialRewardsDescMapping[2] = 5;
        specialPropMaxlimitMapping[2] = 1.0 szabo;
    }

    // Controller，
    function OWNER_SetCTL(ControllerDelegate ctl) external KOwnerOnly {
        _CTL = ctl;
    }

    // 
    function OWNER_SetPhoenixInterface(PhoenixInterface phInc) external KOwnerOnly {
        phInterface = phInc;
    }

    function pauseable() external readonly returns (bool) {
        super.implementcall();
    }

    // 
    function CTL_InvestQueueAppend(OrderInterface) external readwrite {
        super.implementcall();
    }

    // 
    function CTL_CountDownApplyBegin() external readwrite returns (bool) {
        super.implementcall();
    }

    // 
    function CTL_CountDownStop() external readwrite returns (bool) {
        super.implementcall();
    }

    // 
    function IsLuckDog(address) external readonly returns (bool, uint, bool) {
        super.implementcall();
    }

    // ，0
    function WithdrawLuckAward() external readwrite returns (uint) {
        super.implementcall();
    }

    // 
    function OwnerDistributeAwards() external readwrite {
        super.implementcall();
    }

    // 
    function SetCountdownTime(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetAdditionalAmountMin(uint) external readwrite {
        super.implementcall();
    }

    // （）
    function SetAdditionalTime(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetLuckyDoyTotalCount(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetDefualtProp(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetPropMaxLimit(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetSpecialProp(uint, uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetSpecialPropMaxLimit(uint, uint) external readwrite {
        super.implementcall();
    }
}
