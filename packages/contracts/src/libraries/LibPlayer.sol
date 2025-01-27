// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTilemap} from "./LibTilemap.sol";
import {LibPowerup} from "./LibPowerup.sol";
import {LibCollision} from "./LibCollision.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF, MAX_WIDTH} from "../constants.sol";
import {Direction, TileType} from "../codegen/common.sol";

library LibPlayer {
    function entityKey(address owner) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(owner)));
    }

    function placePlayer(uint32 tileX, uint32 tileY)
        internal
        pure
        returns (uint32 x, uint32 y)
    {
        x = tileX * TILE_SIZE + TILE_HALF;
        y = tileY * TILE_SIZE + TILE_HALF;
    }

    function counterDirections(Direction dir)
        internal
        pure
        returns (Direction[2] memory counterDirs)
    {
        if (dir == Direction.Left || dir == Direction.Right) {
            counterDirs = [Direction.Down, Direction.Up];
        } else {
            counterDirs = [Direction.Right, Direction.Left];
        }
    }

    function applyDirection(uint32 x, uint32 y, uint32 speed, Direction dir)
        internal
        pure
        returns (uint32, uint32)
    {
        if (dir == Direction.Up) y = speed > y ? 0 : y - speed;
        if (dir == Direction.Down) y += speed;
        if (dir == Direction.Left) x = speed > x ? 0 : x - speed;
        if (dir == Direction.Right) x += speed;
        return (x, y);
    }

    function move(bytes memory map, uint32 x, uint32 y, uint32 speed, Direction direction)
        internal
        pure
        returns (uint32, uint32)
    {
        (bool blocked, bool c1, bool c2) = LibPlayer.detectCollision(map, x, y, direction);
        if (blocked) return (x, y);

        Direction[2] memory counters = counterDirections(direction);
        if (c1) direction = counters[0];
        if (c2) direction = counters[1];

        return applyDirection(x, y, speed, direction);
    }

    function detectCollision(bytes memory map, uint32 x, uint32 y, Direction direction)
        internal
        pure
        returns (bool blocked, bool c1, bool c2)
    {
        if (LibTilemap.outOfBounds(x, y)) return (true, false, false);

        uint32[2][2] memory tiles = LibCollision.getCollisionTiles(x, y, direction);

        bool coordMatch = tiles[0][0] == tiles[1][0] && tiles[0][1] == tiles[1][1];
        TileType t1 = LibTilemap.getTile(map, tiles[0][0], tiles[0][1]);
        TileType t2 = LibTilemap.getTile(map, tiles[1][0], tiles[1][1]);

        c1 = LibCollision.isCollisionTile(t1);
        c2 = LibCollision.isCollisionTile(t2);
        bool case1 = coordMatch && c1;
        bool case2 = c1 && c2;
        blocked = case1 || case2;
    }
}
