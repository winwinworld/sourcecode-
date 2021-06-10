pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolImpl is AssertPoolState {
    modifier AuthAddressOnly {
        require(authAddress == msg.sender, "InvalidOperation");
        _;
    }

    function PoolNameFromOperator(address operator)
        public
        returns (AssertPoolName)
    {
        for (uint256 i = 0; i < operators.length; i++) {
            if (operators[i] == operator) {
                return AssertPoolName(i);
            }
        }

        return AssertPoolName.Nullable;
    }

    // 
    function Allowance(address operator) external returns (uint256) {
        for (uint256 i = 0; i < operators.length; i++) {
            if (operators[i] == operator) {
                return availTotalAmouns[i];
            }
        }

        // WriteCode
        return 0;
    }

    // 
    function OperatorSend(address to, uint256 amount) external {
        AssertPoolName pname = PoolNameFromOperator(msg.sender);

        // 
        require(availTotalAmouns[uint256(pname)] >= amount);

        // WriteCode
        // 
        availTotalAmouns[uint256(pname)] -= amount;

        // 
        ERC20Interface(address(usdtInterface)).transfer(address(to), amount);
    }

    // CTL，，
    function Auth_RecipientDelegate(uint256 amount) external AuthAddressOnly {
        for (uint256 i = 0; i < availTotalAmouns.length; i++) {
            availTotalAmouns[i] += (amount * matchings[i]) / 1 szabo;
        }
    }

    // 
    function ImportConfig() external KOwnerOnly {
        uint256 balanceUSD = usdtInterface.balanceOf(address(this));

        /// 
        for (uint256 i = 0; i < availTotalAmouns.length; i++) {
            availTotalAmouns[i] = (balanceUSD * matchings[i]) / 1 szabo;
        }
    }
}
