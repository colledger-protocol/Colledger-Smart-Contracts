//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

interface IIdentity {

    function init(bytes memory _UID, uint8 _countryCode) external;

    function getUID() external view returns(bytes memory);

    function getCountryCode() external view returns(uint8);

}