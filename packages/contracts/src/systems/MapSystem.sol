// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
// import {GameConfig, Map, Position} from "../codegen/index.sol";
import {LibTilemap} from "../libraries/Libraries.sol";
import {TileType} from "../codegen/common.sol";
import {MAX_WIDTH, MAX_HEIGHT} from "../constants.sol";

contract MapSystem is System {
// function createMap(TileType[MAX_WIDTH][MAX_HEIGHT] memory data) public returns (bytes32 mapEntity) {
// bytes memory map = LibTilemap.pack(data);
// mapEntity = LibTilemap.entityKey(map);

// require(keccak256(Map.get()) == keccak256(hex""), "Map already exists");
// Map.set(map);
// }
}
