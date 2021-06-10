pragma solidity >=0.5.1 <0.7.0;

interface CounterManagerInterface {

    // 
    function InfomationOf(address owner) external returns (
        // 
        bool isvaild,
        // 
        uint vaildMemberTotal,
        // 
        uint selfAchievements,
        // D
        uint dlevel
    );

    // 
    function UpgradeDLevel() external returns (uint origin, uint current);

    // D1
    function PaymentDLevel(uint) external returns (bool);

    // 
    function SetRecommendAwardProp(uint l, uint p) external;

    // D
    function SetDLevelAwardProp(uint dl, uint p) external;

    // D
    function SetDLevelSearchDepth(uint depth) external;

    // D1，
    function SetDlevel1DepositedNeed(uint need) external;

    // D1DT
    function SetDLevelPrices(uint lv, uint prices) external;

    function LevelListOf(uint) external returns (address[] memory);
}
