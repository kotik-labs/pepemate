// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {rngRange, rngNext} from "./LibUtils.sol";
import {coordToIndex} from "./LibTile.sol";
import {TileType} from "../codegen/common.sol";
import {MAX_WIDTH, MAX_HEIGHT} from "../constants.sol";
import {Entity} from "../Entity.sol";

function entityKey(bytes memory map) pure returns (Entity) {
    return Entity.wrap(keccak256(map));
}

function getTile(bytes memory map, uint32 tileIndex) pure returns (TileType tile) {
    tile = TileType(uint8(map[tileIndex]));
}

function putTile(bytes memory map, uint32 tileIndex, TileType tile) pure returns (bytes memory) {
    map[tileIndex] = bytes1(uint8(tile));
    return map;
}

function fillWalls(bytes memory tileMap, uint256 maxWalls, uint256 seed) pure returns (bytes memory) {
    uint256 rng = rngNext(seed);
    uint256 rngX;
    uint256 rngY;

    for (uint32 i = 0; i < maxWalls;) {
        (rng, rngX) = rngRange(rng, 1, MAX_WIDTH - 1);
        (rng, rngY) = rngRange(rng, 1, MAX_HEIGHT - 1);
        bool rect1 = rngX > 3 && rngX < MAX_WIDTH - 4;
        bool rect2 = rngY > 3 && rngY < MAX_HEIGHT - 4;
        if (!rect1 && !rect2) continue;

        TileType tile = getTile(tileMap, coordToIndex(uint32(rngX), uint32(rngY), MAX_WIDTH));
        if (tile != TileType.Grass) continue;

        tileMap = putTile(tileMap, coordToIndex(uint32(rngX), uint32(rngY), MAX_WIDTH), TileType.Wall);
        i++;
    }

    return tileMap;
}
