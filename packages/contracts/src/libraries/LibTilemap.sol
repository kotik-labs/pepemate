// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibUtils} from "./LibUtils.sol";
import {LibPowerup} from "./LibPowerup.sol";
import {TileType, Direction} from "../codegen/common.sol";
import {MAX_WIDTH, MAX_HEIGHT, TILE_SIZE, TILE_HALF} from "../constants.sol";

library LibTilemap {
    function entityKey(bytes memory map) internal pure returns (bytes32) {
        return keccak256(map);
    }

    function outOfBounds(uint32 x, uint32 y) internal pure returns (bool) {
        bool top = y < TILE_HALF;
        bool left = x < TILE_HALF;
        bool right = y > MAX_HEIGHT * TILE_SIZE - TILE_HALF;
        bool bottom = x > MAX_WIDTH * TILE_SIZE - TILE_HALF;
        return top || left || right || bottom;
    }

    function getTileCoord(uint32 x, uint32 y)
        internal
        pure
        returns (uint32 tileX, uint32 tileY)
    {
        tileX = x / TILE_SIZE;
        tileY = y / TILE_SIZE;
    }

    function coordToIndex(uint32 tileX, uint32 tileY)
        internal
        pure
        returns (uint32 index)
    {
        return (tileY * MAX_WIDTH) + tileX;
    }

    function indexToCoord(uint32 index)
        internal
        pure
        returns (uint32 tileX, uint32 tileY)
    {
        require(index < MAX_WIDTH * MAX_HEIGHT, "Index out of bounds");
        tileX = index % MAX_WIDTH;
        tileY = index / MAX_WIDTH;
    }

    function getTile(bytes memory map, uint32 tileX, uint32 tileY)
        internal
        pure
        returns (TileType tile)
    {
        tile = TileType(uint8(map[coordToIndex(tileX, tileY)]));
    }

    function putTile(bytes memory map, uint32 tileX, uint32 tileY, TileType tile)
        internal
        pure
        returns (bytes memory)
    {
        map[coordToIndex(tileX, tileY)] = bytes1(uint8(tile));
        return map;
    }

    function fillWalls(
        uint32[4] memory spawnIndexes,
        bytes memory tileMap,
        uint256 maxWalls,
        uint256 seed
    ) internal pure returns (bytes memory) {
        uint256 rng = LibUtils.rngNext(seed);
        uint256 rngX;
        uint256 rngY;

        for (uint32 i = 0; i < maxWalls;) {
            (rng, rngX) = LibUtils.rngRange(rng, 1, MAX_WIDTH - 1);
            (rng, rngY) = LibUtils.rngRange(rng, 1, MAX_HEIGHT - 1);

            TileType tile = getTile(tileMap, uint32(rngX), uint32(rngY));
            if (tile != TileType.Grass) continue;

            tileMap = putTile(tileMap, uint32(rngX), uint32(rngY), TileType.Wall);
            i++;
        }

        // TODO: clean all neighbor wall around spawn indexes

        return tileMap;
    }

    function generatePowerup(bytes memory map, uint32 tileX, uint32 tileY, uint256 rng)
        internal
        pure
        returns (uint256, bytes memory)
    {
        TileType possiblyPowerup;
        (rng, possiblyPowerup) = LibPowerup.samplePowerup(rng);
        map = LibTilemap.putTile(map, tileX, tileY, possiblyPowerup);
        return (rng, map);
    }

    function pickupPowerup(bytes memory map, uint32 tileX, uint32 tileY)
        internal
        pure
        returns (TileType powerup, bytes memory)
    {
        TileType tile = LibTilemap.getTile(map, tileX, tileY);
        if (!LibPowerup.isPowerupTile(tile)) return (TileType.None, map);
        map = LibTilemap.putTile(map, tileX, tileY, TileType.Grass);
        return (tile, map);
    }
}
