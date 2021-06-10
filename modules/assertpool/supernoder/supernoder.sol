pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolSuperNoder is AssertPoolSuperNoderState, KContract {

    constructor(
        CounterManagerInterface _managerInterface,
        AssertPoolInterface _apInterface,
        Hosts host
    ) public {

        _KHost = host;

        lastDistributeTime = now / 1 days * 1 days;
        managerInterface = _managerInterface;
        apInterface = _apInterface;
    }

    // 
    function distributeHolderAward() external readwrite {
        super.implementcall();
    }

    function getInfomation(address) external readwrite returns (uint, uint, uint, uint) {
        super.implementcall();
    }
}
