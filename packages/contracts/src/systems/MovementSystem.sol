// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibPlayer, LibTilemap, LibTick, LibTile} from "../libraries/Libraries.sol";
import {
    Player,
    Position,
    TileLookup,
    SessionState,
    FireCount,
    BombCount,
    BombUsed,
    Session,
    LastBombIndex
} from "../codegen/index.sol";
import {Direction, EntityType, TileType} from "../codegen/common.sol";
import {TILE_SIZE, BASE_SPEED, BASE_BOMB_COUNT, BASE_BOMB_RANGE, TILE_HALF, MOVE_COST} from "../constants.sol";
import {Entity} from "../Entity.sol";

function min(uint32 a, uint32 b) pure returns (uint32) {
    return a > b ? b : a;
}

contract MovementSystem is System {
    function move(Direction direction) public {
        _move(direction);
    }

    function move(Direction direction, uint256 steps) public {
        for (uint256 i; i < steps; ++i) {
            _move(direction);
        }
    }

    function _move(Direction direction) internal {
        Entity entity = LibPlayer.entityKey(_msgSender());
        Entity session = Session.get(entity);

        require(!session.isEmpty(), "Session not found");
        // require(Owner.get(entity) == _msgSender(), "Player is not controlled by sender");
        require(Player.get(entity), "Player is dead");

        bytes memory map = SessionState.getMap(session);
        (uint32 oldX, uint32 oldY) = Position.get(entity);
        (uint32 nextX, uint32 nextY) = LibPlayer.move(map, oldX, oldY, BASE_SPEED, direction);

        uint32 oldIndex = LibTile.getTileIndex(oldX, oldY);
        uint32 nextIndex = LibTile.getTileIndex(nextX, nextY);
        if (_blockedByPlayer(session, nextIndex, entity)) return;
        if (_blockedByBomb(session, nextIndex, entity)) return;

        _pickupPowerup(session, entity, map, nextIndex);
        _updatePlayerLookup(session, entity, oldIndex, nextIndex);
        Position.set(entity, nextX, nextY);
        LibTick.update(entity, MOVE_COST);
    }

    function _blockedByPlayer(Entity session, uint32 tileIndex, Entity player) internal view returns (bool) {
        Entity otherPlayer = TileLookup.get(session, tileIndex, EntityType.Player);
        return !otherPlayer.isEmpty() && !otherPlayer.equals(player);
    }

    function _blockedByBomb(Entity session, uint32 tileIndex, Entity player) internal returns (bool) {
        uint32 bombIndex = LastBombIndex.get(player);
        if (tileIndex == bombIndex) return false;
        // reset bomb index if needed
        if (bombIndex != 0) LastBombIndex.set(player, 0);

        Entity bomb = TileLookup.get(session, tileIndex, EntityType.Bomb);
        return !bomb.isEmpty();
    }

    function _pickupPowerup(Entity session, Entity entity, bytes memory map, uint32 tileIndex) internal {
        TileType powerUp;
        (powerUp, map) = LibTilemap.pickupPowerup(map, tileIndex);
        if (powerUp != TileType.None) {
            SessionState.setMap(session, map);
        }

        if (powerUp == TileType.RangeUp) {
            FireCount.set(entity, min(FireCount.get(entity) + 1, 16));
        }

        if (powerUp == TileType.BombsUp) {
            BombCount.set(entity, min(BombCount.get(entity) + 1, 16));
        }
    }

    function _updatePlayerLookup(Entity session, Entity entity, uint32 oldIndex, uint32 nextIndex) internal {
        if (oldIndex == nextIndex) return;
        TileLookup.set(session, oldIndex, EntityType.Player, Entity.wrap(0));
        TileLookup.set(session, nextIndex, EntityType.Player, entity);
    }
}
