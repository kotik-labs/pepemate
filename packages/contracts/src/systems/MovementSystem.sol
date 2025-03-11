// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {pickupPowerup} from "../libraries/LibPowerup.sol";
import {getTileIndex} from "../libraries/LibTile.sol";
import {applyMove} from "../libraries/LibPlayer.sol";
import {updateTick} from "../libraries/LibTick.sol";
import {
    Player,
    Position,
    TileLookup,
    FireCount,
    BombCount,
    BombUsed,
    MatchLookup,
    MatchTerrain,
    LastBombIndex
} from "../codegen/index.sol";
import {Direction, EntityType, TileType} from "../codegen/common.sol";
import {
    TILE_SIZE, BASE_SPEED, BASE_BOMB_COUNT, BASE_BOMB_RANGE, TILE_HALF, MOVE_COST, MAX_WIDTH
} from "../constants.sol";
import {Entity} from "../Entity.sol";

function min(uint32 a, uint32 b) pure returns (uint32) {
    return a > b ? b : a;
}

contract MovementSystem is System {
    function move(Direction direction) public {
        (Entity matchEntity, Entity player) = MatchLookup.get(_msgSender());
        _move(direction, matchEntity, player);
    }

    function move(Direction direction, uint256 steps) public {
        (Entity matchEntity, Entity player) = MatchLookup.get(_msgSender());
        for (uint256 i; i < steps; ++i) {
            _move(direction, matchEntity, player);
        }
    }

    function _move(Direction direction, Entity matchEntity, Entity playerEntity) internal {
        bytes memory map = MatchTerrain.getTerrain(matchEntity);
        (uint32 oldX, uint32 oldY) = Position.get(playerEntity);

        (uint32 nextX, uint32 nextY) = applyMove(matchEntity, playerEntity, oldX, oldY, direction, map);
        uint32 oldIndex = getTileIndex(oldX, oldY, MAX_WIDTH);
        uint32 nextIndex = getTileIndex(nextX, nextY, MAX_WIDTH);

        _pickupPowerup(matchEntity, playerEntity, map, nextIndex);
        _updatePlayerLookup(matchEntity, playerEntity, oldIndex, nextIndex);
        Position.set(playerEntity, nextX, nextY);
        updateTick(playerEntity, MOVE_COST);
    }

    function _pickupPowerup(Entity matchEntity, Entity entity, bytes memory map, uint32 tileIndex) internal {
        TileType powerUp;
        (powerUp, map) = pickupPowerup(map, tileIndex);
        if (powerUp != TileType.None) {
            MatchTerrain.setTerrain(matchEntity, map);
        }

        if (powerUp == TileType.RangeUp) {
            FireCount.set(entity, min(FireCount.get(entity) + 1, 16));
        }

        if (powerUp == TileType.BombsUp) {
            BombCount.set(entity, min(BombCount.get(entity) + 1, 16));
        }
    }

    function _updatePlayerLookup(Entity matchEntity, Entity entity, uint32 oldIndex, uint32 nextIndex) internal {
        if (oldIndex == nextIndex) return;
        TileLookup.deleteRecord(matchEntity, oldIndex, EntityType.Player);
        TileLookup.set(matchEntity, nextIndex, EntityType.Player, entity);
    }
}
