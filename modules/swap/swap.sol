pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Swap is SwapState, KContract {
    constructor(
        ERC777Interface usdInc,
        AssertPoolInterface astPoolInc,
        PhoenixInterface _phoenixInc,
        ERC777Interface _pttInc,
        Hosts host
    ) public {
        _KHost = host;
        usdtInterface = usdInc;
        phoenixInc = _phoenixInc;
        astPool = astPoolInc;
        pttInterface = _pttInc;

        //  1 USDT = 20 DT
        // 
        //      1e6(wei) : 20e18(wei)
        //    = 1e6 : 2e19
        //    = 1 : 2e13
        //    = 20e12
        swapInfo = Info(
            1, //roundID
            100000 ether, //total
            0, //current
            50 //prop
        );
    }

    // usdt
    function Doswaping(uint256)
        external
        readwrite
        returns (DoswapingError, uint256)
    {
        super.implementcall();
    }

    // 
    function OwnerUpdateSwapInfo(uint256, uint256) external readwrite {
        super.implementcall();
    }

    // 
    function exchangeLimit(address) public returns (uint256) {
        super.implementcall();
    }

    function shouldChange(address, uint256) external returns (bool) {
        super.implementcall();
    }

    function Owner_SetChangeQuota(uint256, uint256) external {
        super.implementcall();
    }
}
