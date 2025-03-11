// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {getTileIndex} from "./LibTile.sol";
import {getTile} from "./LibTilemap.sol";
import {TILE_HALF, MAX_HEIGHT, MAX_WIDTH, TILE_SIZE} from "../constants.sol";
import {Direction, TileType, EntityType} from "../codegen/common.sol";
import {TileLookup} from "../codegen/index.sol";
import {Entity} from "../Entity.sol";

function isCollisionTile(TileType t) pure returns (bool) {
    return t == TileType.Wall || t == TileType.Block;
}

function outOfBounds(uint32 x, uint32 y) pure returns (bool) {
    // TODO: get width and height from session map
    bool top = y < TILE_HALF;
    bool left = x < TILE_HALF;
    bool right = y > MAX_HEIGHT * TILE_SIZE - TILE_HALF;
    bool bottom = x > MAX_WIDTH * TILE_SIZE - TILE_HALF;
    return top || left || right || bottom;
}

function getCollisionTiles(uint32 x, uint32 y, Direction direction) pure returns (uint32[2] memory tileIndexes) {
    if (direction == Direction.Up) {
        tileIndexes[0] = getTileIndex(x - TILE_HALF, y - TILE_HALF - 1, MAX_WIDTH);
        tileIndexes[1] = getTileIndex(x + TILE_HALF - 1, y - TILE_HALF - 1, MAX_WIDTH);
    }

    if (direction == Direction.Left) {
        tileIndexes[0] = getTileIndex(x - TILE_HALF - 1, y - TILE_HALF, MAX_WIDTH);
        tileIndexes[1] = getTileIndex(x - TILE_HALF - 1, y + TILE_HALF - 1, MAX_WIDTH);
    }

    if (direction == Direction.Right) {
        tileIndexes[0] = getTileIndex(x + TILE_HALF, y - TILE_HALF, MAX_WIDTH);
        tileIndexes[1] = getTileIndex(x + TILE_HALF, y + TILE_HALF - 1, MAX_WIDTH);
    }

    if (direction == Direction.Down) {
        tileIndexes[0] = getTileIndex(x - TILE_HALF, y + TILE_HALF, MAX_WIDTH);
        tileIndexes[1] = getTileIndex(x + TILE_HALF - 1, y + TILE_HALF, MAX_WIDTH);
    }
}

function detectCollision(Entity matchEntity, Entity player, bytes memory map, uint32[2] memory tileIndexes)
    view
    returns (bool blocked, bool c1, bool c2)
{
    bool coordMatch = tileIndexes[0] == tileIndexes[1];

    if (coordMatch) {
        // short cicuit for matched collision coords
        TileType t = getTile(map, tileIndexes[0]);
        Entity p = TileLookup.get(matchEntity, tileIndexes[0], EntityType.Player);
        Entity b = TileLookup.get(matchEntity, tileIndexes[0], EntityType.Bomb);

        blocked = isCollisionTile(t) || (!p.isEmpty() && !p.equals(player)) || !b.isEmpty();
        c1 = blocked;
        return (blocked, c1, c2);
    }

    TileType t1 = getTile(map, tileIndexes[0]);
    TileType t2 = getTile(map, tileIndexes[1]);
    Entity p1 = TileLookup.get(matchEntity, tileIndexes[0], EntityType.Player);
    Entity p2 = TileLookup.get(matchEntity, tileIndexes[1], EntityType.Player);
    Entity b1 = TileLookup.get(matchEntity, tileIndexes[0], EntityType.Bomb);
    Entity b2 = TileLookup.get(matchEntity, tileIndexes[1], EntityType.Bomb);

    c1 = isCollisionTile(t1) || (!p1.isEmpty() && !p1.equals(player)) || !b1.isEmpty();
    c2 = isCollisionTile(t2) || (!p2.isEmpty() && !p2.equals(player)) || !b2.isEmpty();

    bool case1 = coordMatch && c1;
    bool case2 = c1 && c2;
    blocked = case1 || case2;
}
