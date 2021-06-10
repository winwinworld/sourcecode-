pragma solidity >=0.5.1 <0.7.0;

import "../../order/interface.sol";

interface AssertPoolSuperNoderInterface {

    event Log_DistributeHolderAward(address indexed owner, uint indexed lv, uint time, uint award);

    function distributeHolderAward() external;

    function getInfomation(address) external returns (uint lastDistributeTime, uint totalWithdraw, uint v4award, uint v5award);
}
