//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract IdentityFactory is Initializable{

    address identityImplementation;
    address admin;
     
    mapping(string => bool) public identityExist;

}