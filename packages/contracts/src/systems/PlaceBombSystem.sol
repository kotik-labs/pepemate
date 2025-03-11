// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {
    Player,
    BombIndex,
    Position,
    MatchLookup,
    EntityMatch,
    FireCount,
    BombCount,
    BombUsed,
    BombOwner,
    BombRange,
    TileLookup,
    LastBombIndex
} from "../codegen/index.sol";
import {TileType, EntityType} from "../codegen/common.sol";
import {getTileIndex} from "../libraries/LibTile.sol";
import {updateTick} from "../libraries/LibTick.sol";
import {DIR_COUNT, PLANT_BOMB_COST, MAX_WIDTH} from "../constants.sol";

import {Entity} from "../Entity.sol";
import {createEntity} from "../createEntity.sol";

contract PlaceBombSystem is System {
    function placeBomb() public {
        (Entity matchEntity, Entity player) = MatchLookup.get(_msgSender());

        require(!matchEntity.isEmpty(), "Session not found");
        require(Player.get(player), "Player is dead");

        (uint32 px, uint32 py) = Position.get(player);
        uint32 tileIndex = getTileIndex(px, py, MAX_WIDTH);
        require(TileLookup.get(matchEntity, tileIndex, EntityType.Bomb).isEmpty(), "Bomb placed here already");

        uint32 max = BombCount.get(player);
        uint32 count = BombUsed.get(player);
        require(count < max, "No more bombs");

        Entity bomb = createEntity();
        BombIndex.set(bomb, tileIndex);
        BombOwner.set(bomb, player);
        BombRange.set(bomb, FireCount.get(player));

        EntityMatch.set(bomb, matchEntity);
        TileLookup.set(matchEntity, tileIndex, EntityType.Bomb, bomb);

        LastBombIndex.set(player, tileIndex);
        BombUsed.set(player, count + 1);
        updateTick(player, PLANT_BOMB_COST);
    }
}
