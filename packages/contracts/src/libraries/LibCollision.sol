// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTilemap} from "./LibTilemap.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF, MAX_WIDTH} from "../constants.sol";
import {Direction, TileType} from "../codegen/common.sol";

library LibCollision {
    function isCollisionTile(TileType t) internal pure returns (bool) {
        return t == TileType.Wall || t == TileType.Block;
    }

    function getCollisionTiles(uint32 x, uint32 y, Direction direction)
        internal
        pure
        returns (uint32[2][2] memory tiles)
    {
        if (direction == Direction.Up) {
            (tiles[0][0], tiles[0][1]) =
                LibTilemap.getTileCoord(x - TILE_HALF, y - TILE_HALF - 1);
            (tiles[1][0], tiles[1][1]) =
                LibTilemap.getTileCoord(x + TILE_HALF - 1, y - TILE_HALF - 1);
        }

        if (direction == Direction.Left) {
            (tiles[0][0], tiles[0][1]) =
                LibTilemap.getTileCoord(x - TILE_HALF - 1, y - TILE_HALF);
            (tiles[1][0], tiles[1][1]) =
                LibTilemap.getTileCoord(x - TILE_HALF - 1, y + TILE_HALF - 1);
        }

        if (direction == Direction.Right) {
            (tiles[0][0], tiles[0][1]) =
                LibTilemap.getTileCoord(x + TILE_HALF, y - TILE_HALF);
            (tiles[1][0], tiles[1][1]) =
                LibTilemap.getTileCoord(x + TILE_HALF, y + TILE_HALF - 1);
        }

        if (direction == Direction.Down) {
            (tiles[0][0], tiles[0][1]) =
                LibTilemap.getTileCoord(x - TILE_HALF, y + TILE_HALF);
            (tiles[1][0], tiles[1][1]) =
                LibTilemap.getTileCoord(x + TILE_HALF - 1, y + TILE_HALF);
        }
    }
}
