// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {indexToCoord} from "./LibTile.sol";
import {getCollisionTiles, detectCollision} from "./LibCollision.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF, MAX_WIDTH, MAX_HEIGHT} from "../constants.sol";
import {Direction, TileType, EntityType} from "../codegen/common.sol";
import {Entity} from "../Entity.sol";

function placePlayer(uint32 tileIndex) pure returns (uint32 x, uint32 y) {
    (uint32 tileX, uint32 tileY) = indexToCoord(tileIndex, MAX_WIDTH, MAX_HEIGHT);
    x = tileX * TILE_SIZE + TILE_HALF;
    y = tileY * TILE_SIZE + TILE_HALF;
}

function counterDirections(Direction dir) pure returns (Direction[2] memory counterDirs) {
    if (dir == Direction.Left || dir == Direction.Right) {
        counterDirs = [Direction.Down, Direction.Up];
    } else {
        counterDirs = [Direction.Right, Direction.Left];
    }
}

function applyDirection(uint32 x, uint32 y, uint32 speed, Direction dir) pure returns (uint32, uint32) {
    if (dir == Direction.Up) y = speed > y ? 0 : y - speed;
    if (dir == Direction.Down) y += speed;
    if (dir == Direction.Left) x = speed > x ? 0 : x - speed;
    if (dir == Direction.Right) x += speed;
    return (x, y);
}

function applyMove(Entity matchEntity, Entity playerEntity, uint32 x, uint32 y, Direction direction, bytes memory map)
    view
    returns (uint32, uint32)
{
    uint32[2] memory tileIndexes = getCollisionTiles(x, y, direction);
    (bool blocked, bool c1, bool c2) = detectCollision(matchEntity, playerEntity, map, tileIndexes);
    if (blocked) return (x, y);

    Direction[2] memory counters = counterDirections(direction);
    if (c1) direction = counters[0];
    if (c2) direction = counters[1];

    return applyDirection(x, y, BASE_SPEED, direction);
}

function playerIndex(Entity player, bytes32[4] memory players) pure returns (bool, uint256) {
    bytes32 _p = player.unwrap();

    for (uint256 i = 0; i < 4; ++i) {
        if (_p == players[i]) {
            return (true, i);
        }
    }

    return (false, type(uint256).max);
}
