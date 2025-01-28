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

contract SpawnSystem is System {
    function spawn() public {
        address owner = _msgSender();
        bytes32 entity = LibPlayer.entityKey(owner);
        require(!Player.get(entity), "Player is alive");

        bytes32 session = SessionOf.get(entity);
        uint8 index = PlayerIndex.get(entity);
        require(session != bytes32(0), "Session not found");
        require(index < 4, "invalid player index");

        uint32[4] memory spawnIndexes = Session.getSpawnIndexes(session);
        (uint32 tileX, uint32 tileY) = LibTilemap.indexToCoord(spawnIndexes[index]);
        _initPlayer(session, entity, tileX, tileY);
    }

    function _resetLookup(bytes32 session, bytes32 entity) internal {
        (uint32 oldX, uint32 oldY) = Position.get(entity);
        (oldX, oldY) = LibTilemap.getTileCoord(oldX, oldY);
        TileLookup.set(session, oldX, oldY, EntityType.Player, bytes32(0));
    }

    function _initPlayer(bytes32 session, bytes32 entity, uint32 tileX, uint32 tileY) internal {
        _resetLookup(session, entity);
        (uint32 x, uint32 y) = LibPlayer.placePlayer(tileX, tileY);

        Player.set(entity, true);
        // Speed.set(entity, BASE_SPEED);
        BombCount.set(entity, BASE_BOMB_COUNT);
        BombUsed.set(entity, 0);
        FireCount.set(entity, BASE_BOMB_RANGE);
        Position.set(entity, x, y);
        TileLookup.set(session, tileX, tileY, EntityType.Player, entity);
    }
}
