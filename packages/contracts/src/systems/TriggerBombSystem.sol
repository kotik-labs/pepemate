// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {TileType, EntityType} from "../codegen/common.sol";
import {
    Map,
    Player,
    BombIndex,
    Position,
    BombOwner,
    BombUsed,
    SessionMap,
    BombRange,
    TileLookup
} from "../codegen/index.sol";
import {LibBomb, LibTile, LibTilemap, LibUtils} from "../libraries/Libraries.sol";
import {DIR_COUNT, PLANT_BOMB_COST} from "../constants.sol";
import {Entity} from "../Entity.sol";

contract TriggerBombSystem is System {
    function triggerBomb(Entity session, uint32 tileX, uint32 tileY) public {
        // TODO: fuse logic
        uint32 tileIndex = LibTile.coordToIndex(tileX, tileY);
        Entity bomb = LibBomb.entityKey(session, tileIndex);
        if (BombIndex.get(bomb) == 0) return;

        bytes memory map = SessionMap.getTerrain(session);
        uint256 rng = LibUtils.rngSeed();

        (, map) = _triggerBomb(session, bomb, tileIndex, rng, map);
        SessionMap.setTerrain(session, map);
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

        BombIndex.deleteRecord(bomb);
        BombOwner.deleteRecord(bomb);
        TileLookup.deleteRecord(session, tileIndex, EntityType.Bomb);

        uint32 range = BombRange.get(bomb);
        bool megaBombPowerup = false; // tODO

        LibBomb.Destruction[] memory tilesToUpdate = LibBomb.getExplodedTiles(map, tileIndex, range, megaBombPowerup);

        for (uint256 i; i < tilesToUpdate.length; i++) {
            uint32 updateIndex = tilesToUpdate[i].index;
            if (updateIndex == 0) continue;
            if (!LibBomb.isUndestructable(tilesToUpdate[i].tile)) {
                map = LibTilemap.putTile(map, updateIndex, TileType.Grass);
            }

            // generate random powerup if wall
            if (tilesToUpdate[i].tile == TileType.Wall) {
                (rng, map) = LibTilemap.generatePowerup(map, updateIndex, rng);
                continue;
            }

            Entity playerOnBomb = TileLookup.get(session, updateIndex, EntityType.Player);
            if (!playerOnBomb.isEmpty()) {
                Player.deleteRecord(playerOnBomb);
                Position.deleteRecord(playerOnBomb);
                TileLookup.deleteRecord(session, updateIndex, EntityType.Player);
            }

            Entity nextBomb = TileLookup.get(session, updateIndex, EntityType.Bomb);
            if (!nextBomb.isEmpty()) {
                (rng, map) = _triggerBomb(session, nextBomb, updateIndex, rng, map);
            }
        }
    }
}
