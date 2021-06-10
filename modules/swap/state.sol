pragma solidity >=0.5.1 <0.7.0;

import "./interface.sol";

import "../../core/KContract.sol";
import "../../core/interface/ERC777Interface.sol";
import "../../core/interface/ERC20Interface.sol";
import "../assertpool/interface.sol";
import "../phoenix/interface.sol";

contract SwapState is SwapInterface, KState(0x6b0331b4) {
    // 
    uint256 public swapedTotalSum;

    Info public swapInfo;

    ERC777Interface public usdtInterface;

    ERC777Interface public pttInterface;

    AssertPoolInterface public astPool;

    /// USDT
    uint256 public nomalAddressQuota = 50e18;

    /// USDT
    uint256 public vaildAddressQuota = 500e18;

    ///  ->  -> 
    mapping(address => mapping(uint256 => uint256)) public quotaMapping;

    PhoenixInterface internal phoenixInc;
}
