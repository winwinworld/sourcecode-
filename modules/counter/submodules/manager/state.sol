pragma solidity >=0.5.1 <0.7.0;

import "../../../../core/interface/ERC777Interface.sol";
import "../../../../core/interface/ERC20Interface.sol";
import "../../../../core/KContract.sol";
import "../../../relationship/interface.sol";
import "../../../reward/interface.sol";

import "../../interface.sol";
import "./interface.sol";

contract CounterManagerState is
    CounterModulesInterface,
    CounterManagerInterface,
    KState(0x722a41a7)
{
    // ,
    address public authorizedAddress;

    // 
    RelationshipInterface public RLTInterface;

    // 
    uint256[] public awardProp = [
        0.20 szabo, // 1
        0.10 szabo, // 2
        0.05 szabo, // 3
        0.03 szabo, // 4
        0.03 szabo, // 5
        0.03 szabo, // 6
        0.03 szabo, // 7
        0.03 szabo, // 8
        0.03 szabo, // 9
        0.03 szabo, // 10
        0.03 szabo, // 11
        0.03 szabo, // 12
        0.05 szabo, // 13
        0.10 szabo, // 14
        0.20 szabo // 15
    ];

    // D
    uint256[] public dlevelAwarProp = [
        uint256(0.000 szabo),
        uint256(0.005 szabo),
        uint256(0.005 szabo),
        uint256(0.005 szabo),
        uint256(0.005 szabo),
        uint256(0.005 szabo)
    ];

    // 
    uint256 public dlvDepthMaxLimit = 512;

    // D1，,()
    uint256 public dlv1DepositedNeed = 10000e18;

    // D1USDT
    uint256[] public dlvPrices = [0, 300e18, 500e18];

    // USDT
    ERC777Interface internal usdtInterface;

    RewardInterface internal rewardInterface;

    // 
    mapping(address => bool) public vaildAddressMapping;

    // 
    mapping(address => uint256) public vaildAddressCountMapping;

    // 
    mapping(address => uint256) public selfAchievementMapping;

    // D
    mapping(address => uint8) public dlevelMapping;
    mapping(uint256 => address[]) internal _levelListMapping;

    // ,，dlevel
    mapping(address => uint8) public dlevelMemberMaxMapping;

    // D1
    mapping(address => bool) public depositedGreatThanD1;

    // 5000U
    mapping(address => bool) public depositedGreatThan5000USD;
}
