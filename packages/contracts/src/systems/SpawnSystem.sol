// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {playerIndex, placePlayer} from "../libraries/LibPlayer.sol";
import {getTileIndex} from "../libraries/LibTile.sol";
import {Player, Position, FireCount, BombCount, BombUsed} from "../codegen/index.sol";
import {Map, MatchConfig, MatchPlayers, TileLookup, MatchLookup} from "../codegen/index.sol";
import {EntityType} from "../codegen/common.sol";
import {BASE_BOMB_COUNT, BASE_BOMB_RANGE, MAX_WIDTH} from "../constants.sol";
import {Entity} from "../Entity.sol";

contract SpawnSystem is System {
    function spawn() public {
        (Entity matchEntity, Entity player) = MatchLookup.get(_msgSender());

        require(!matchEntity.isEmpty(), "Session not found");
        require(!Player.get(player), "Player is alive");

        bytes32[4] memory players = MatchPlayers.get(matchEntity);
        (bool found, uint256 index) = playerIndex(player, players);
        require(found, "Player not found in matchEntity");

        uint32[4] memory spawnIndexes = Map.getSpawnIndexes(MatchConfig.getMapId(matchEntity));
        _initPlayer(matchEntity, player, spawnIndexes[index]);
    }

    function _initPlayer(Entity matchEntity, Entity player, uint32 tileIndex) internal {
        (uint32 newX, uint32 newY) = placePlayer(tileIndex);

        Player.set(player, true);
        Position.set(player, newX, newY);
        FireCount.set(player, BASE_BOMB_RANGE);
        BombCount.set(player, BASE_BOMB_COUNT);
        BombUsed.set(player, 0);

        (uint32 oldX, uint32 oldY) = Position.get(player);
        uint32 oldIndex = getTileIndex(oldX, oldY, MAX_WIDTH);
        TileLookup.set(matchEntity, oldIndex, EntityType.Player, Entity.wrap(0));
        TileLookup.set(matchEntity, tileIndex, EntityType.Player, player);
    }
}
