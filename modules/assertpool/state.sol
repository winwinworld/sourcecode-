pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "../../core/interface/ERC777Interface.sol";
import "../../core/interface/ERC20Interface.sol";

import "./interface.sol";

contract AssertPoolState is AssertPoolInterface, KState(0xbdfa5467) {
    // ，100%
    uint256[5] public matchings = [
        0,
        0.40 szabo,
        0.30 szabo,
        0.20 szabo,
        0.10 szabo
    ];

    // 
    uint256[5] public availTotalAmouns = [0, 0, 0, 0, 0];

    // ，
    address[5] public operators = [
        address(0x0),
        address(0x0),
        address(0x0),
        address(0x0),
        address(0x0)
    ];

    ERC777Interface internal usdtInterface;

    address internal authAddress;
}
