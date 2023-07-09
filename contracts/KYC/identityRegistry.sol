//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "contracts/interfaces/IIdentity.sol";

contract identityRegistry is Initializable {

    struct IdentityStorage {
        bytes UID;
        uint8 countryCode;
    }

    address public admin;

    address public identityFactory;

    mapping(address => bool) identityVerified;

    mapping(address => IdentityStorage) storeIdentity;

    modifier onlyAdmin() {
        require(msg.sender == admin || msg.sender == identityFactory,"Not admin.");
        _;
    }

    function init(address _admin, address _identityFactory) external initializer {
        admin = _admin;
        identityFactory = _identityFactory;
    } 

    function registerIdentity(address _identity) external onlyAdmin returns(bool) {
        require(_identity!=address(0), "Address Zero.");
        storeIdentity[_identity].UID = IIdentity(_identity).getUID();
        storeIdentity[_identity].countryCode = IIdentity(_identity).getCountryCode();
        identityVerified[_identity] = true;
        return identityVerified[_identity];
    }

    function revokeIdentity(address _identity) external onlyAdmin {
        require(_identity!=address(0),"Zero address.");
        storeIdentity[_identity].UID = bytes(abi.encodePacked("0"));
        storeIdentity[_identity].countryCode = 0;
        identityVerified[_identity] = false;
    }

    function verifyIdentity(address _identity) external view returns(bool) {
        return identityVerified[_identity];
    }


}