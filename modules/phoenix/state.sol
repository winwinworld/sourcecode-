pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "../../core/interface/ERC777Interface.sol";

import "../swap/state.sol";
import "../controller/interface.sol";
import "../assertpool/awards/interface.sol";
import "./interface.sol";

contract PhoenixState is PhoenixInterface, KState(0x4eb1d593) {
    // 
    mapping(uint256 => mapping(address => InoutTotal)) public inoutMapping;

    // 
    mapping(address => Compensate) public compensateMapping;

    // ,，，，
    // 
    uint256 public dataStateVersion = 0;

    // 
    uint256 public compensateRelaseProp = 0.01 szabo;

    // 
    uint256 public compensateProp = 0;

    // CTL
    ControllerDelegate internal _CTL;

    // _ASTPoolAwards
    AssertPoolAwardsInterface internal _ASTPoolAwards;

    ERC777Interface internal pttInterface;

    SwapState internal swapState;
}
