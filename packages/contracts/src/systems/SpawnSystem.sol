// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibPlayer, LibTilemap, LibTile} from "../libraries/Libraries.sol";
import {Player, Position, FireCount, BombCount, BombUsed} from "../codegen/index.sol";
import {EntitySession, Map, SessionMap, SessionPlayers, TileLookup} from "../codegen/index.sol";
import {EntityType} from "../codegen/common.sol";
import {BASE_BOMB_COUNT, BASE_BOMB_RANGE} from "../constants.sol";
import {Entity} from "../Entity.sol";

contract SpawnSystem is System {
    function spawn() public {
        Entity entity = LibPlayer.entityKey(_msgSender());
        Entity session = EntitySession.get(entity);

        require(!session.isEmpty(), "Session not found");
        require(!Player.get(entity), "Player is alive");

        bytes32[4] memory players = SessionPlayers.get(session);
        (bool found, uint256 index) = LibPlayer.playerIndex(entity, players);
        require(found, "Player not found in session");

        uint32[4] memory spawnIndexes = Map.getSpawnIndexes(SessionMap.getMapId(session));
        _initPlayer(session, entity, spawnIndexes[index]);
    }

    function _initPlayer(Entity session, Entity entity, uint32 tileIndex) internal {
        (uint32 newX, uint32 newY) = LibPlayer.placePlayer(tileIndex);

        Player.set(entity, true);
        Position.set(entity, newX, newY);
        FireCount.set(entity, BASE_BOMB_RANGE);
        BombCount.set(entity, BASE_BOMB_COUNT);
        BombUsed.set(entity, 0);

        (uint32 oldX, uint32 oldY) = Position.get(entity);
        uint32 oldIndex = LibTile.getTileIndex(oldX, oldY);
        TileLookup.set(session, oldIndex, EntityType.Player, Entity.wrap(0));
        TileLookup.set(session, tileIndex, EntityType.Player, entity);
    }
}
