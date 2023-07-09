//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

interface IColledgerFactory {

    function verifyIdentity(address _identity) external view returns(bool);

}

contract ColledgerIdentity is Initializable {

IColledgerFactory public colledgerFactory; 

bytes identificationNumber;
uint8 countryCode;

address[] instituteCredentialAddresses;
address[] employerCredentialAddresses;

address lastEmployer;
address lastInstitution;

function init(bytes memory _UID, uint8 _countryCode) external initializer { 
    identificationNumber = _UID;
    countryCode = _countryCode;
}

function addInstitute(address _institute) external {
    instituteCredentialAddresses.push(_institute);
    lastInstitution = _institute;
}

function addEmployer(address _employer) external {
    employerCredentialAddresses.push(_employer);
    lastEmployer = _employer;
}

function getUID() external view returns(bytes memory) {
    return identificationNumber;
}

function getCountryCode() external view returns(uint8){
    return countryCode;
}

}