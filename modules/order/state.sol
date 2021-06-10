pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "../../core/interface/ERC20Interface.sol";

import {ControllerDelegate} from "../controller/interface.sol";
import {ConfigInterface} from "../config/interface.sol";
import {CounterModulesInterface} from "../counter/interface.sol";

import "./interface.sol";

contract OrderState is OrderInterface, KState(0xcb150bf5) {
    // 
    mapping(uint8 => uint256) public times;

    // 
    OrderInterface.OrderType public orderType;

    // 
    uint256 public totalAmount;

    // 
    uint256 public toHelpedAmount;

    // 
    uint256 public getHelpedAmount;

    // 
    uint256 public getHelpedAmountTotal;

    // 
    uint256 public paymentPartMinLimit;

    // 
    uint256 public createdPaymentAmount;

    // 
    OrderInterface.OrderStates public orderState;

    // ,
    bool public nextOrderVaild;

    // 
    address public contractOwner;

    // 
    uint256 public orderIndex;

    // 
    // [0] 
    // [1] 
    mapping(uint256 => uint256) public blockRange;

    // 
    ERC20Interface internal _usdtInterface;
    ConfigInterface internal _configInterface;
    ControllerDelegate internal _CTL;
    CounterModulesInterface internal _counterInteface;
}
