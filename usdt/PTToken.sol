/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
pragma solidity >=0.5.1 <0.7.0;

/// @title ERC777 ReferenceToken Contract
/// @author Jordi Baylina, Jacques Dafflon
/// @dev This token contract's goal is to give an example implementation
///  of ERC777 with ERC20 compatible.
///  This contract does not define any standard, but can be taken as a reference
///  implementation in case of any ambiguity into the standard

import "../tools/Ownable.sol";
import "../tools/SafeMath.sol";

import {ERC20Token} from "./ERC20Token.sol";
import {ERC777Token} from "./ERC777Token.sol";

contract WINToken is Ownable, ERC20Token, ERC777Token {
    using SafeMath for uint256;

    string private mName;
    string private mSymbol;
    uint256 private mGranularity;
    uint256 private mTotalSupply;
    uint8 private mDecimal;
    address[] private mDefaultOperators;

    mapping(address => uint256) private mBalances;
    mapping(address => mapping(address => bool)) private mAuthorized;
    mapping(address => mapping(address => uint256)) private mAllowed;

    /* -- Constructor -- */
    //
    /// @notice Constructor to create a ReferenceToken
    /// @param _name Name of the new token
    /// @param _symbol Symbol of the new token.
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 totalSupply,
        uint8 decimal
    ) public {
        mDecimal = decimal;
        mName = _name;
        mSymbol = _symbol;
        mTotalSupply = totalSupply * 10**uint256(decimal);
        mGranularity = 1;

        mBalances[msg.sender] = mTotalSupply;
        mDefaultOperators.push(msg.sender);
    }

    function addDefaultOperators(address owner)
        external
        onlyOwner
        returns (bool)
    {
        mDefaultOperators.push(owner);
    }

    function removeDefaultOperators(address owner)
        external
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < mDefaultOperators.length; i++) {
            if (mDefaultOperators[i] == owner) {
                for (uint256 j = i; j < mDefaultOperators.length - 1; j++) {
                    mDefaultOperators[j] = mDefaultOperators[j + 1];
                }
                delete mDefaultOperators[mDefaultOperators.length - 1];
                mDefaultOperators.length--;
                return true;
            }
        }

        return false;
    }

    /* -- ERC777 Interface Implementation -- */
    //
    /// @return the name of the token
    function name() external view returns (string memory) {
        return mName;
    }

    /// @notice For Backwards compatibility
    function decimals() external view returns (uint8) {
        return mDecimal;
    }

    /// @return the symbol of the token
    function symbol() external view returns (string memory) {
        return mSymbol;
    }

    /// @return the granularity of the token
    function granularity() external view returns (uint256) {
        return mGranularity;
    }

    /// @return the total supply of the token
    function totalSupply() external view returns (uint256) {
        return mTotalSupply;
    }

    function defaultOperators() external view returns (address[] memory) {
        return mDefaultOperators;
    }

    /// @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
    /// @param _operator The operator that wants to be Authorized
    function authorizeOperator(address _operator) external {
        require(_operator != msg.sender);
        mAuthorized[_operator][msg.sender] = true;
        emit AuthorizedOperator(_operator, msg.sender);
    }

    /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
    /// @param _operator The operator that wants to be Revoked
    function revokeOperator(address _operator) external {
        require(_operator != msg.sender);
        mAuthorized[_operator][msg.sender] = false;
        emit RevokedOperator(_operator, msg.sender);
    }

    /// @notice Return the account balance of some account
    /// @param _tokenHolder Address for which the balance is returned
    /// @return the balance of `_tokenAddress`.
    function balanceOf(address _tokenHolder) external view returns (uint256) {
        return mBalances[_tokenHolder];
    }

    /// @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
    /// @param _to The address of the recipient
    /// @param _amount The number of tokens to be sent
    function send(
        address _to,
        uint256 _amount,
        bytes calldata _userData
    ) external {
        doSend(msg.sender, _to, _amount, _userData, msg.sender, "");
    }

    /// @notice Check whether the `_operator` address is allowed to manage the tokens held by `_tokenHolder` address.
    /// @param _operator address to check if it has the right to manage the tokens
    /// @param _tokenHolder address which holds the tokens to be managed
    /// @return `true` if `_operator` is authorized for `_tokenHolder`
    function isOperatorFor(address _operator, address _tokenHolder)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < mDefaultOperators.length; i++) {
            if (mDefaultOperators[i] == _operator) {
                return true;
            }
        }

        return
            _operator == _tokenHolder || mAuthorized[_operator][_tokenHolder];
    }

    /// @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
    /// @param _from The address holding the tokens being sent
    /// @param _to The address of the recipient
    /// @param _amount The number of tokens to be sent
    /// @param _userData Data generated by the user to be sent to the recipient
    /// @param _operatorData Data generated by the operator to be sent to the recipient
    function operatorSend(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _userData,
        bytes calldata _operatorData
    ) external {
        require(isOperatorFor(msg.sender, _from));
        doSend(_from, _to, _amount, _userData, msg.sender, _operatorData);
    }

    /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived are) -- */
    //
    /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
    ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
    /// @param _tokenHolder The address that will be assigned the new tokens
    /// @param _amount The quantity of tokens generated
    /// @param _operatorData Data that will be passed to the recipient as a first transfer
    function mint(
        address _tokenHolder,
        uint256 _amount,
        bytes calldata _operatorData
    ) external onlyOwner {
        mTotalSupply = mTotalSupply.add(_amount);
        mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);

        emit Minted(msg.sender, _tokenHolder, _amount, "", _operatorData);
    }

    /// @notice Burns `_amount` tokens from `_tokenHolder`
    ///  Sample burn function to showcase the use of the `Burned` event.
    /// @param _amount The quantity of tokens to burn
    /// @param _data Data generated by the user to be sent to the recipient
    function burn(uint256 _amount, bytes calldata _data) external {
        require(mBalances[msg.sender] >= _amount);

        mBalances[msg.sender] = mBalances[msg.sender].sub(_amount);
        mBalances[address(0x0)] = mBalances[address(0x0)].add(_amount);

        mTotalSupply = mTotalSupply.sub(_amount);

        emit Burned(msg.sender, msg.sender, _amount, _data, "");
    }

    function operatorBurn(
        address _from,
        uint256 _amount,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external {
        require(isOperatorFor(msg.sender, _from));

        require(mBalances[_from] >= _amount);

        mBalances[_from] = mBalances[_from].sub(_amount);
        mBalances[address(0x0)] = mBalances[address(0x0)].add(_amount);

        mTotalSupply = mTotalSupply.sub(_amount);

        emit Burned(msg.sender, _from, _amount, _data, _operatorData);
    }

    /// @notice ERC20 backwards compatible transfer.
    /// @param _to The address of the recipient
    /// @param _amount The number of tokens to be transferred
    /// @return `true`, if the transfer can't be done, it should fail.
    function transfer(address _to, uint256 _amount)
        external
        returns (bool success)
    {
        doSend(msg.sender, _to, _amount, "", msg.sender, "");
        return true;
    }

    /// @notice ERC20 backwards compatible transferFrom.
    /// @param _from The address holding the tokens being transferred
    /// @param _to The address of the recipient
    /// @param _amount The number of tokens to be transferred
    /// @return `true`, if the transfer can't be done, it should fail.
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external returns (bool success) {
        require(_amount <= mAllowed[_from][msg.sender]);

        // Cannot be after doSend because of tokensReceived re-entry
        mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
        doSend(_from, _to, _amount, "", msg.sender, "");
        return true;
    }

    /// @notice ERC20 backwards compatible approve.
    ///  `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _amount The number of tokens to be approved for transfer
    /// @return `true`, if the approve can't be done, it should fail.
    function approve(address _spender, uint256 _amount)
        external
        returns (bool success)
    {
        mAllowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    /// @notice ERC20 backwards compatible allowance.
    ///  This function makes it easy to read the `allowed[]` map
    /// @param _owner The address of the account that owns the token
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens of _owner that _spender is allowed
    ///  to spend
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining)
    {
        return mAllowed[_owner][_spender];
    }

    /// @notice Check whether an address is a regular address or not.
    /// @param _addr Address of the contract that has to be checked
    /// @return `true` if `_addr` is a regular address (not a contract)
    function isRegularAddress(address _addr) internal view returns (bool) {
        if (_addr == address(0)) {
            return false;
        }
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        } // solhint-disable-line no-inline-assembly
        return size == 0;
    }

    /// @notice Helper function actually performing the sending of tokens.
    /// @param _from The address holding the tokens being sent
    /// @param _to The address of the recipient
    /// @param _amount The number of tokens to be sent
    /// @param _userData Data generated by the user to be passed to the recipient
    /// @param _operatorData Data generated by the operator to be passed to the recipien
    ///  implementing `erc777_tokenHolder`.
    ///  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
    ///  functions SHOULD set this parameter to `false`.
    function doSend(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _userData,
        address _operator,
        bytes memory _operatorData
    ) private {
        require(_to != address(0)); // forbid sending to 0x0 (=burning)
        require(mBalances[_from] >= _amount); // ensure enough funds

        mBalances[_from] = mBalances[_from].sub(_amount);
        mBalances[_to] = mBalances[_to].add(_amount);

        emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
    }
}
