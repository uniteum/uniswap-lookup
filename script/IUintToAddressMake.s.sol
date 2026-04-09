// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script, console2} from "forge-std/Script.sol";
import {IUintToAddressMaker} from "ilookup/IUintToAddressMaker.sol";

/// @notice Deploy an AddressLookup clone ONLY if it doesn't already exist (idempotent).
/// @dev Environment variables (required):
///   - IUintToAddressMaker :
///   - kvAbi :
/// @dev Usage: forge script script/IUintToAddressMake.s.sol -f $chain --private-key $tx_key --broadcast
contract IUintToAddressMake is Script {
    function run() external {
        console2.log("script   : AddressLookupMake");
        address proto = vm.envAddress("IUintToAddressMaker");
        bytes memory kvAbi = vm.envBytes("kvAbi");

        IUintToAddressMaker.KeyValue[] memory keyValues = abi.decode(kvAbi, (IUintToAddressMaker.KeyValue[]));

        (, address predicted,) = IUintToAddressMaker(proto).made(keyValues);
        console2.log("predicted:", predicted);

        string memory action = "reused";
        address actual = predicted;
        if (actual.code.length == 0) {
            vm.startBroadcast();
            actual = IUintToAddressMaker(proto).make(keyValues);
            vm.stopBroadcast();
            action = "deployed";
        }

        console2.log("action   :", action);
        console2.log("actual   :", actual);
    }
}
