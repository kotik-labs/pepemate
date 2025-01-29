// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {
    Player,
    BombIndex,
    Position,
    Session,
    Map,
    SessionState,
    FireCount,
    BombCount,
    BombUsed,
    BombOwner,
    BombRange,
    TileLookup,
    LastBombIndex
} from "../codegen/index.sol";
import {TileType, EntityType} from "../codegen/common.sol";
import {LibPlayer, LibBomb, LibTile, LibTilemap, LibPowerup, LibTick, LibUtils} from "../libraries/Libraries.sol";
import {DIR_COUNT, PLANT_BOMB_COST} from "../constants.sol";
import {Entity} from "../Entity.sol";

contract BombSystem is System {
    function placeBomb() public {
        Entity player = LibPlayer.entityKey(_msgSender());
        Entity session = Session.get(player);

        require(!session.isEmpty(), "Session not found");
        // require(Owner.get(player) == _msgSender(), "Player is not controlled by sender");
        require(Player.get(player), "Player is dead");

        (uint32 px, uint32 py) = Position.get(player);
        uint32 tileIndex = LibTile.getTileIndex(px, py);
        (uint32 tileX, uint32 tileY) = LibTile.indexToCoord(tileIndex);
        require(TileLookup.get(session, tileIndex, EntityType.Bomb).isEmpty(), "Bomb placed here already");

        uint32 max = BombCount.get(player);
        uint32 count = BombUsed.get(player);
        require(count < max, "No more bombs");

        Entity bomb = LibBomb.entityKey(session, tileIndex);
        BombIndex.set(bomb, tileIndex);
        BombOwner.set(bomb, player);
        BombRange.set(bomb, FireCount.get(player));

        Session.set(bomb, session);
        TileLookup.set(session, tileIndex, EntityType.Bomb, bomb);

        LastBombIndex.set(player, tileIndex);
        BombUsed.set(player, count + 1);
        LibTick.update(player, PLANT_BOMB_COST);
    }

    function triggerBomb(Entity session, uint32 tileX, uint32 tileY) public {
        // TODO: fuse logic
        uint32 tileIndex = LibTile.coordToIndex(tileX, tileY);
        Entity bomb = LibBomb.entityKey(session, tileIndex);
        if (BombIndex.get(bomb) == 0) return;

        bytes memory map = SessionState.getMap(session);
        uint256 rng = LibUtils.rngSeed();

        (, map) = _triggerBomb(session, bomb, tileIndex, rng, map);
        SessionState.setMap(session, map);
    }

    function _triggerBomb(Entity session, Entity bomb, uint32 tileIndex, uint256 rng_, bytes memory map_)
        internal
        returns (uint256 rng, bytes memory map)
    {
        rng = rng_;
        map = map_;

        Entity player = BombOwner.get(bomb);
        uint32 used = BombUsed.get(player);
        BombUsed.set(player, used > 0 ? used - 1 : 0);

        BombIndex.set(bomb, 0);
        BombOwner.set(bomb, Entity.wrap(0));
        TileLookup.set(session, tileIndex, EntityType.Bomb, Entity.wrap(0));

        uint32 range = BombRange.get(bomb);
        bool megaBombPowerup = false; // tODO

        LibBomb.Destruction[] memory tilesToUpdate = LibBomb.getExplodedTiles(map, tileIndex, range, megaBombPowerup);

        for (uint256 i; i < tilesToUpdate.length; i++) {
            uint32 updateIndex = tilesToUpdate[i].index;
            if (updateIndex == 0) continue;
            if (LibBomb.isUndestructable(tilesToUpdate[i].tile)) continue;

            map = LibTilemap.putTile(map, updateIndex, TileType.Grass);

            // generate random powerup if wall
            if (tilesToUpdate[i].tile == TileType.Wall) {
                (rng, map) = LibTilemap.generatePowerup(map, updateIndex, rng);
                continue;
            }

            Entity playerOnBomb = TileLookup.get(session, updateIndex, EntityType.Player);
            if (!playerOnBomb.isEmpty()) {
                Player.set(playerOnBomb, false);
                Position.set(playerOnBomb, 0, 0);
                TileLookup.set(session, updateIndex, EntityType.Player, Entity.wrap(0));
            }

            Entity nextBomb = TileLookup.get(session, updateIndex, EntityType.Bomb);
            if (!nextBomb.isEmpty()) {
                (rng, map) = _triggerBomb(session, nextBomb, updateIndex, rng, map);
            }
        }
    }
}
