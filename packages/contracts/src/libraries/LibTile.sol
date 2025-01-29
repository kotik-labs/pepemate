// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibUtils} from "./LibUtils.sol";
import {LibPowerup} from "./LibPowerup.sol";
import {TileType, Direction} from "../codegen/common.sol";
import {MAX_WIDTH, MAX_HEIGHT, TILE_SIZE, TILE_HALF} from "../constants.sol";

library LibTile {
    function getTileIndex(uint32 x, uint32 y) internal pure returns (uint32 tileIndex) {
        return coordToIndex(x / TILE_SIZE, y / TILE_SIZE);
    }

    function coordToIndex(uint32 tileX, uint32 tileY) internal pure returns (uint32 index) {
        return (tileY * MAX_WIDTH) + tileX;
    }

    function indexToCoord(uint32 index) internal pure returns (uint32 tileX, uint32 tileY) {
        require(index < MAX_WIDTH * MAX_HEIGHT, "Index out of bounds");
        tileX = index % MAX_WIDTH;
        tileY = index / MAX_WIDTH;
    }
}
