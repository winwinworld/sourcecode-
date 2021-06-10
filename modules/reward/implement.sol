pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract RewardImpl is RewardState {
    modifier ControllerOnly {
        require(_CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    function RewardInfo(address owner)
        external
        returns (
            uint256 rewardAmount,
            uint256 totalDeposit,
            uint256 totalRewardedAmount
        )
    {
        DepositedInfo memory info = rewardMapping[owner];

        return (info.rewardAmount, info.totalDeposit, info.totalRewardedAmount);
    }

    // ,
    function CTL_ClearHistoryDelegate(address breaker) external ControllerOnly {
        delete rewardMapping[breaker];
    }

    // 
    function CTL_AddReward(
        address owner,
        uint256 amount,
        CounterModulesInterface.AwardType atype
    ) external ControllerOnly {
        rewardMapping[owner].rewardAmount += amount;

        emit Log_Award(owner, atype, now, amount);
    }

    // ,
    function CTL_CreatedOrderDelegate(address owner, uint256 amount)
        external
        ControllerOnly
    {
        rewardMapping[owner].totalDeposit += amount;
    }

    // ，OnlyGH，
    function CTL_CreatedAwardOrderDelegate(address owner, uint256 amount)
        external
        ControllerOnly
        returns (bool)
    {
        DepositedInfo storage info = rewardMapping[owner];

        // ，
        if (info.totalRewardedAmount + amount > info.totalDeposit) {
            return false;
        }

        if (info.rewardAmount >= amount) {
            info.rewardAmount -= amount;
            info.totalRewardedAmount += amount;
            return true;
        }

        return false;
    }

    function Import(
        address sender,
        uint256 rewardAmount,
        uint256 totalRewardedAmount,
        uint256 totalDeposit
    ) external KOwnerOnly {
        rewardMapping[sender].rewardAmount = rewardAmount;
        rewardMapping[sender].totalRewardedAmount = totalRewardedAmount;
        rewardMapping[sender].totalDeposit = totalDeposit;
    }
}
