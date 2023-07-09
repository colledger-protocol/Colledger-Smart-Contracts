//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "contracts/interfaces/IIdentity.sol";
import "contracts/interfaces/IIDRegistry.sol";


contract IdentityFactory is Initializable{

    address identityImplementation;
    address identityRegistry;
    address admin;
    uint totalIdentitiesDeployed;
     
    mapping(bytes => bool) identityExist; // uniqueId => bool 

    mapping(bytes => address) identityAddress; // uniqueId => identityAddress

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin.");
        _;
    }

    function init(address _template, address _registry, address _admin) external {
        require(_template!=address(0) && _registry!=address(0) && _admin!=address(0),"Zero Address");
        identityImplementation = _template;
        identityRegistry = _registry;
        admin = _admin;
    }

    function createAndRegisterIdentity(bytes memory _UID, uint8 _countryCode) external onlyAdmin {
        require(!identityExist[_UID],"Identity already exist");
        totalIdentitiesDeployed++;
        bytes32 salt = keccak256(abi.encodePacked(totalIdentitiesDeployed,_UID,_countryCode));
        address identity = ClonesUpgradeable.cloneDeterministic(identityImplementation, salt);
        identityAddress[_UID] = identity;
        IIdentity(identity).init(_UID, _countryCode);
        IIDRegistry(identityRegistry).registerIdentity(identity);
    }

    



}