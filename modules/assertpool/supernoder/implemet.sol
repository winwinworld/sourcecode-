pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolSuperNoderImpl is AssertPoolSuperNoderState {

    function getInfomation(address owner) external returns (uint lastDistributeTime, uint totalWithdraw, uint v4award, uint v5award) {

        /// 1.Q4 Q5
        address[] memory dlv4_addresses = managerInterface.LevelListOf(4);
        address[] memory dlv5_addresses = managerInterface.LevelListOf(5);

        /// 2.
        uint totalAwards = apInterface.Allowance(address(this));

        if ( dlv4_addresses.length > 0 ) {
            v4award = totalAwards / 2 / dlv4_addresses.length;
        }

        if ( dlv5_addresses.length > 0 ) {
            v5award = totalAwards / 2 / dlv5_addresses.length;
        }

        return (lastDistributeTime, totalBounds[owner], v4award, v5award);
    }

    function distributeHolderAward() external KOwnerOnly {

        uint dayz = now / 1 days * 1 days;
        require( dayz - lastDistributeTime >= 7 days );
        lastDistributeTime = dayz;

        /// 1.Q4 Q5
        address[] memory dlv4_addresses = managerInterface.LevelListOf(4);
        address[] memory dlv5_addresses = managerInterface.LevelListOf(5);

        /// 2.
        uint totalAwards = apInterface.Allowance(address(this));

        uint v4award = 0;
        uint v5award = 0;
        if ( dlv4_addresses.length > 0 ) {
            v4award = totalAwards / 2 / dlv4_addresses.length;
        }

        if ( dlv5_addresses.length > 0 ) {
            v5award = totalAwards / 2 / dlv5_addresses.length;
        }

        /// 3.V4
        for (uint i = 0; i < dlv4_addresses.length; i++) {
            totalBounds[dlv4_addresses[i]] += v4award;
            apInterface.OperatorSend(dlv4_addresses[i], v4award);
            emit Log_DistributeHolderAward(dlv4_addresses[i], 4, now, v4award);
        }

        /// 3.V5
        for (uint i = 0; i < dlv5_addresses.length; i++) {
            totalBounds[dlv5_addresses[i]] += v5award;
            apInterface.OperatorSend(dlv5_addresses[i], v5award);
            emit Log_DistributeHolderAward(dlv5_addresses[i], 5, now, v5award);
        }
    }
}
