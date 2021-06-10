pragma solidity >=0.5.1 <0.7.0;

import "../../../core/interface/ERC777Interface.sol";
import "../../../core/KContract.sol";

import "../../controller/interface.sol";
import "../../order/interface.sol";
import "../../phoenix/interface.sol";

import "../interface.sol";
import "./interface.sol";

contract AssertPoolAwardsState is
    AssertPoolAwardsInterface,
    KState(0xd0affae8)
{
    ///////////////////////////////////////////////////////////
    /// CountDown                                           ///
    ///////////////////////////////////////////////////////////
    // 
    bool public isInCountdowning = false;

    // 
    uint256 public countdownTime = 36 hours;

    // (mwei)
    uint256 public additionalAmountMin = 100e18;

    // ()
    uint256 public additionalTime = 3600;

    // 
    uint256 public deadlineTime;

    // 
    bool public death = false;

    ///////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    // 
    OrderInterface[] public investOrdersQueue;

    // 
    uint256 public luckyDoyTotalCount = 300;

    // 
    uint256 public defualtProp = 3;

    // 
    uint256 public propMaxLimit = 0.02 szabo;

    // 
    mapping(uint256 => uint256) public specialRewardsDescMapping;

    // 
    mapping(uint256 => uint256) public specialPropMaxlimitMapping;

    // 
    mapping(address => LuckyDog) public luckydogMapping;

    AssertPoolInterface internal apInterface;
    ControllerDelegate internal _CTL;
    ERC777Interface internal usdtInterface;
    PhoenixInterface internal phInterface;
}
