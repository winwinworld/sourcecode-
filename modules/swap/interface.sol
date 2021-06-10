pragma solidity >=0.5.1 <0.7.0;

interface SwapInterface {

    struct Info {
        // 
        uint roundID;
        // 
        uint total;
        // 
        uint current;
        // 
        uint prop;
    }

    enum DoswapingError {
        // 
        NoError,
        // 
        AllowanceInsufficient,
        // 
        BalanceInsufficient,
        // 
        SwapBalanceInsufficient
    }

    // ,
    event Log_UpdateSwapInfo(uint when, address who, uint total, uint prop);

    // USDTToken
    event Log_Swaped(address indexed owner, uint time, uint inAmount, uint outAmount);

    // usdt
    function Doswaping(uint amount) external returns (DoswapingError code, uint tokenAmount);

    // 
    function OwnerUpdateSwapInfo(uint total, uint prop) external;

    // 
    function exchangeLimit(address owner) external returns(uint);

    function shouldChange(address owner, uint amountOfUSD) external returns(bool);

    function Owner_SetChangeQuota(uint nomal, uint vaild) external;
}
