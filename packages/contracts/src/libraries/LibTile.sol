// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {TILE_SIZE} from "../constants.sol";

function getTileIndex(uint32 x, uint32 y, uint32 maxWidth) pure returns (uint32 tileIndex) {
    return coordToIndex(x / TILE_SIZE, y / TILE_SIZE, maxWidth);
}

function coordToIndex(uint32 tileX, uint32 tileY, uint32 maxWidth) pure returns (uint32 index) {
    return (tileY * maxWidth) + tileX;
}

function indexToCoord(uint32 index, uint32 maxWidth, uint32 maxHeight) pure returns (uint32 tileX, uint32 tileY) {
    require(index < maxWidth * maxHeight, "Index out of bounds");
    tileX = index % maxWidth;
    tileY = index / maxWidth;
}
