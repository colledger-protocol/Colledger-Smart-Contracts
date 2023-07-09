//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

interface IColledgerFactory {

    function verifyIdentity(address _identity) external view returns(bool);

}


contract ColledgerIdentity {

IColledgerFactory colledgerFactory; 

uint identificationNumber;
uint countryCode;

address[] instituteCredentialAddresses;
address[] employerCredentialAddresses;

address currentEmployer;
address currentInstitution;

function verifyIdentity() external view returns(bool) {
    return colledgerFactory.verifyIdentity(address(this));
}

}