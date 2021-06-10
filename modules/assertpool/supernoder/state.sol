pragma solidity >=0.5.1 <0.7.0;

import "../../../core/interface/ERC777Interface.sol";
import "../../../core/KContract.sol";

import "../../counter/submodules/manager/interface.sol";

import "../interface.sol";
import "./interface.sol";

contract AssertPoolSuperNoderState is
    AssertPoolSuperNoderInterface,
    KState(0x6a201676)
{
    uint256 public lastDistributeTime = 0;

    mapping(address => uint256) public totalBounds;

    CounterManagerInterface public managerInterface;

    AssertPoolInterface internal apInterface;
}
