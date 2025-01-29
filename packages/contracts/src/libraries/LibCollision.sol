// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTile} from "./LibTile.sol";
import {LibTilemap} from "./LibTilemap.sol";
import {TILE_HALF} from "../constants.sol";
import {Direction, TileType} from "../codegen/common.sol";

library LibCollision {
    function isCollisionTile(TileType t) internal pure returns (bool) {
        return t == TileType.Wall || t == TileType.Block;
    }

    function getCollisionTiles(uint32 x, uint32 y, Direction direction)
        internal
        pure
        returns (uint32[2] memory tileIndexes)
    {
        if (direction == Direction.Up) {
            tileIndexes[0] = LibTile.getTileIndex(x - TILE_HALF, y - TILE_HALF - 1);
            tileIndexes[1] = LibTile.getTileIndex(x + TILE_HALF - 1, y - TILE_HALF - 1);
        }

        if (direction == Direction.Left) {
            tileIndexes[0] = LibTile.getTileIndex(x - TILE_HALF - 1, y - TILE_HALF);
            tileIndexes[1] = LibTile.getTileIndex(x - TILE_HALF - 1, y + TILE_HALF - 1);
        }

        if (direction == Direction.Right) {
            tileIndexes[0] = LibTile.getTileIndex(x + TILE_HALF, y - TILE_HALF);
            tileIndexes[1] = LibTile.getTileIndex(x + TILE_HALF, y + TILE_HALF - 1);
        }

        if (direction == Direction.Down) {
            tileIndexes[0] = LibTile.getTileIndex(x - TILE_HALF, y + TILE_HALF);
            tileIndexes[1] = LibTile.getTileIndex(x + TILE_HALF - 1, y + TILE_HALF);
        }
    }

    function detectCollision(bytes memory map, uint32 x, uint32 y, Direction direction)
        internal
        pure
        returns (bool blocked, bool c1, bool c2)
    {
        if (LibTilemap.outOfBounds(x, y)) return (true, false, false);

        uint32[2] memory tileIndexes = LibCollision.getCollisionTiles(x, y, direction);

        bool coordMatch = tileIndexes[0] == tileIndexes[1];
        TileType t1 = LibTilemap.getTile(map, tileIndexes[0]);
        TileType t2 = LibTilemap.getTile(map, tileIndexes[1]);

        c1 = LibCollision.isCollisionTile(t1);
        c2 = LibCollision.isCollisionTile(t2);
        bool case1 = coordMatch && c1;
        bool case2 = c1 && c2;
        blocked = case1 || case2;
    }
}
