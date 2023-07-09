//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

interface IIDRegistry {

    function registerIdentity(address _identity) external returns(bool);

}