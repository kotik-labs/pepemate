// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTile} from "./LibTile.sol";
import {LibTilemap} from "./LibTilemap.sol";
import {LibPowerup} from "./LibPowerup.sol";
import {LibCollision} from "./LibCollision.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF, MAX_WIDTH} from "../constants.sol";
import {Direction, TileType} from "../codegen/common.sol";
import {Entity} from "../Entity.sol";

library LibPlayer {
    function entityKey(address owner) internal pure returns (Entity) {
        return Entity.wrap(bytes32(uint256(uint160(owner))));
    }

    function placePlayer(uint32 tileIndex) internal pure returns (uint32 x, uint32 y) {
        (uint32 tileX, uint32 tileY) = LibTile.indexToCoord(tileIndex);
        x = tileX * TILE_SIZE + TILE_HALF;
        y = tileY * TILE_SIZE + TILE_HALF;
    }

    function counterDirections(Direction dir) internal pure returns (Direction[2] memory counterDirs) {
        if (dir == Direction.Left || dir == Direction.Right) {
            counterDirs = [Direction.Down, Direction.Up];
        } else {
            counterDirs = [Direction.Right, Direction.Left];
        }
    }

    function applyDirection(uint32 x, uint32 y, uint32 speed, Direction dir) internal pure returns (uint32, uint32) {
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
        (bool blocked, bool c1, bool c2) = LibCollision.detectCollision(map, x, y, direction);
        if (blocked) return (x, y);

        Direction[2] memory counters = counterDirections(direction);
        if (c1) direction = counters[0];
        if (c2) direction = counters[1];

        return applyDirection(x, y, speed, direction);
    }

    function playerIndex(Entity player, bytes32[4] memory players) internal pure returns (bool, uint256) {
        bytes32 _p = player.unwrap();
        
        for (uint256 i = 0; i < 4; ++i) {
            if (_p == players[i]) {
                return (true, i);
            }
        }

        return(false, type(uint256).max);
    }
}
