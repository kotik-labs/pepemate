// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {
    Player,
    BombIndex,
    Position,
    EntitySession,
    FireCount,
    BombCount,
    BombUsed,
    BombOwner,
    BombRange,
    TileLookup,
    LastBombIndex
} from "../codegen/index.sol";
import {TileType, EntityType} from "../codegen/common.sol";
import {LibPlayer, LibBomb, LibTile, LibTick} from "../libraries/Libraries.sol";
import {DIR_COUNT, PLANT_BOMB_COST} from "../constants.sol";
import {Entity} from "../Entity.sol";

contract PlaceBombSystem is System {
    function placeBomb() public {
        Entity player = LibPlayer.entityKey(_msgSender());
        Entity session = EntitySession.get(player);

        require(!session.isEmpty(), "Session not found");
        require(Player.get(player), "Player is dead");

        (uint32 px, uint32 py) = Position.get(player);
        uint32 tileIndex = LibTile.getTileIndex(px, py);
        require(TileLookup.get(session, tileIndex, EntityType.Bomb).isEmpty(), "Bomb placed here already");

        uint32 max = BombCount.get(player);
        uint32 count = BombUsed.get(player);
        require(count < max, "No more bombs");

        Entity bomb = LibBomb.entityKey(session, tileIndex);
        BombIndex.set(bomb, tileIndex);
        BombOwner.set(bomb, player);
        BombRange.set(bomb, FireCount.get(player));

        EntitySession.set(bomb, session);
        TileLookup.set(session, tileIndex, EntityType.Bomb, bomb);

        LastBombIndex.set(player, tileIndex);
        BombUsed.set(player, count + 1);
        LibTick.update(player, PLANT_BOMB_COST);
    }
}
