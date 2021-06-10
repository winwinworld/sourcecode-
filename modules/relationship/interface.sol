pragma solidity >=0.5.1 <0.7.0;

interface RelationshipInterface {

    enum AddRelationError {
        // 0.
        NoError,
        // 1.
        CannotBindYourSelf,
        // 2.，
        AlreadyBinded,
        // 3.
        ParentUnbinded,
        // 4.
        ShortCodeExisted
    }

    /////////////////////////////////////////////////////////////////////////////
    //                                Storage                                  //
    /////////////////////////////////////////////////////////////////////////////
    /// 
    function totalAddresses() external view returns (uint);

    /// 
    function rootAddress() external view returns (address);

    /////////////////////////////////////////////////////////////////////////////
    //                                  View                                   //
    /////////////////////////////////////////////////////////////////////////////
    /// ，
    function GetIntroducer(address owner ) external returns (address);

    /// 
    function RecommendList(address owner) external returns (address[] memory list, uint256 len );

    /// 
    function ShortCodeToAddress(bytes6 shortCode ) external returns (address);

    /// 
    function AddressToShortCode(address addr ) external returns (bytes6);

    /// 
    function AddressToNickName(address addr ) external returns (bytes16);

    ///
    function Depth(address addr) external returns (uint);

    /////////////////////////////////////////////////////////////////////////////
    //                                  Write                                  //
    /////////////////////////////////////////////////////////////////////////////
    /// ，6，+
    function RegisterShortCode(bytes6 shortCode ) external returns (bool);

    /// 
    function UpdateNickName(bytes16 name ) external;

    /// 
    function AddRelation(address recommer ) external returns (AddRelationError);

    /// 
    function AddRelationEx(address recommer, bytes6 shortCode, bytes16 nickname) external returns (AddRelationError);

    /// 
    function Import(address owner, address recommer, bytes6 shortcode, bytes16 nickname) external;
}
