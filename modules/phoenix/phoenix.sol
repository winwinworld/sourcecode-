pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Phoenix is PhoenixState, KContract {

    constructor(
        ERC777Interface _pttInc,
        Hosts host
    ) public {
        _KHost = host;
        pttInterface = _pttInc;
    }

    // Controller，
    function OWNER_SetCTL(ControllerDelegate ctl) external KOwnerOnly {
        _CTL = ctl;
    }

    function OWNER_SetSwapInstance(SwapState addr) external KOwnerOnly {
        swapState = addr;
    }

    // AssertPoolAwards，
    function OWNER_SetAssertPoolAwards(AssertPoolAwardsInterface astAwards) external KOwnerOnly {
        _ASTPoolAwards = astAwards;
    }

    function GetInoutTotalInfo(address) external readonly returns (uint, uint) {
        super.implementcall();
    }

    function WithdrawCurrentRelaseCompensate() external readwrite returns (uint) {
        super.implementcall();
    }

    function CTL_AppendAmountInfo(address, uint, uint) external readwrite {
        super.implementcall();
    }

    function CTL_ClearHistoryDelegate(address) external readwrite {
        super.implementcall();
    }

    function CTL_SettlementCompensate(address) external readwrite returns (uint) {
        super.implementcall();
    }

    function ASTPoolAward_PushNewStateVersion() external readwrite {
        super.implementcall();
    }

    // 
    function SetCompensateRelaseProp(uint) external readwrite {
        super.implementcall();
    }

    // 
    function SetCompensateProp(uint) external readwrite {
        super.implementcall();
    }

}
