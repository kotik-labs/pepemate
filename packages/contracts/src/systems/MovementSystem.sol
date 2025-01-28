// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibPlayer, LibTilemap, LibTick} from "../libraries/Libraries.sol";
import {
    Player,
    Position,
    TileLookup,
    Session,
    FireCount,
    BombCount,
    BombUsed,
    SessionOf,
    LastBombPlaced,
    PlayerIndex,
    SessionData
} from "../codegen/index.sol";
import {Direction, EntityType, TileType} from "../codegen/common.sol";
import {TILE_SIZE, BASE_SPEED, BASE_BOMB_COUNT, BASE_BOMB_RANGE, TILE_HALF, MOVE_COST} from "../constants.sol";

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
        address owner = _msgSender();
        bytes32 entity = LibPlayer.entityKey(owner);
        require(Player.get(entity), "Player is dead");
        LibTick.update(entity, MOVE_COST);

        bytes32 session = SessionOf.get(entity);
        require(session != bytes32(0), "Session not found");

        bytes memory map = Session.getMap(session);
        (uint32 x, uint32 y) = Position.get(entity);
        (uint32 nextX, uint32 nextY) = LibPlayer.move(map, x, y, BASE_SPEED, direction);

        (uint32 tileX, uint32 tileY) = LibTilemap.getTileCoord(nextX, nextY);
        (uint32 bombX, uint32 bombY) = LastBombPlaced.get(entity);
        if (_checkPlayer(session, tileX, tileY, entity)) return;
        if (_checkBomb(session, tileX, tileY, bombX, bombY)) return;

        _resetLookup(session, entity);
        _checkPowerups(session, entity, map, tileX, tileY);
        Position.set(entity, nextX, nextY);
        TileLookup.set(session, tileX, tileY, EntityType.Player, entity);
        if (tileX != bombX || tileY != bombY) {
            LastBombPlaced.set(entity, 0, 0);
        }
    }

    function _resetLookup(bytes32 session, bytes32 entity) internal {
        (uint32 oldX, uint32 oldY) = Position.get(entity);
        (oldX, oldY) = LibTilemap.getTileCoord(oldX, oldY);
        TileLookup.set(session, oldX, oldY, EntityType.Player, bytes32(0));
    }

    function _checkPowerups(bytes32 session, bytes32 entity, bytes memory map, uint32 tileX, uint32 tileY) internal {
        TileType powerUp;
        (powerUp, map) = LibTilemap.pickupPowerup(map, tileX, tileY);
        if (powerUp == TileType.None) return;
        if (powerUp == TileType.RangeUp) {
            FireCount.set(entity, min(FireCount.get(entity) + 1, 4));
        }

        if (powerUp == TileType.BombsUp) {
            BombCount.set(entity, min(BombCount.get(entity) + 1, 4));
        }

        if (powerUp == TileType.SpeedUp) {
            // TODO: for know reason moving system start to behave buggy after changing Speed  to any
            // Speed.set(entity, min(Speed.get(entity) * 2, 8));
        }

        Session.setMap(session, map);
    }

    function _checkPlayer(bytes32 session, uint32 tileX, uint32 tileY, bytes32 player)
        internal
        view
        returns (bool blocked)
    {
        bytes32 otherPlayer = TileLookup.get(session, tileX, tileY, EntityType.Player);
        blocked = otherPlayer != bytes32(0) && otherPlayer != player;
    }

    function _checkBomb(bytes32 session, uint32 tileX, uint32 tileY, uint32 bombX, uint32 bombY)
        internal
        view
        returns (bool isBomb)
    {
        bytes32 bomb = TileLookup.get(session, tileX, tileY, EntityType.Bomb);
        if (bombX == tileX && bombY == tileY) return false;
        isBomb = bomb != bytes32(0);
    }
}
