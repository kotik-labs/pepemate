// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {
    Player,
    Bomb,
    Position,
    Session,
    Map,
    PlacedBy,
    SessionOf,
    FireCount,
    BombCount,
    BombUsed,
    BombRange,
    TileLookup,
    LastBombPlaced
} from "../codegen/index.sol";
import {TileType, EntityType} from "../codegen/common.sol";
import {
    LibPlayer,
    LibBomb,
    LibTilemap,
    LibPowerup,
    LibTick,
    LibUtils
} from "../libraries/Libraries.sol";
import {DIR_COUNT, PLANT_BOMB_COST} from "../constants.sol";

contract BombSystem is System {
    function isUndestructable(TileType t) internal pure returns (bool) {
        return t == TileType.SpawnA || t == TileType.SpawnB || t == TileType.SpawnC
            || t == TileType.SpawnD;
    }

    function placeBomb() public returns (bytes32 session, uint32 tileX, uint32 tileY) {
        address owner = _msgSender();
        bytes32 player = LibPlayer.entityKey(owner);
        require(Player.get(player), "Player is dead");
        LibTick.update(player, PLANT_BOMB_COST);

        (uint32 px, uint32 py) = Position.get(player);
        (tileX, tileY) = LibTilemap.getTileCoord(px, py);

        session = SessionOf.get(player);
        require(session != bytes32(0), "Session not found");

        require(
            TileLookup.get(session, tileX, tileY, EntityType.Bomb) == bytes32(0),
            "Bomb placed here already"
        );

        uint32 max = BombCount.get(player);
        uint32 count = BombUsed.get(player);
        require(count < max, "No more bombs");
        BombUsed.set(player, count + 1);

        bytes32 bomb = LibBomb.entityKey(session, tileX, tileY);
        Bomb.set(bomb, true);
        Position.set(bomb, tileX, tileY);
        BombRange.set(bomb, FireCount.get(player));
        SessionOf.set(bomb, session);
        TileLookup.set(session, tileX, tileY, EntityType.Bomb, bomb);
        PlacedBy.set(bomb, player);
        LastBombPlaced.set(player, tileX, tileY);
    }

    function triggerBomb(bytes32 session, uint32 tileX, uint32 tileY) public {
        // TODO: fuse logic
        bytes32 bomb = LibBomb.entityKey(session, tileX, tileY);
        if (!Bomb.get(bomb)) return;

        bytes memory map = Session.getMap(session);
        uint256 rng = LibUtils.rngSeed();

        (, map) = _triggerBomb(session, bomb, tileX, tileY, rng, map);
        Session.setMap(session, map);
    }

    function _triggerBomb(
        bytes32 session,
        bytes32 bomb,
        uint32 tileX,
        uint32 tileY,
        uint256 rng_,
        bytes memory map_
    ) internal returns (uint256 rng, bytes memory map) {
        rng = rng_;
        map = map_;

        bytes32 player = PlacedBy.get(bomb);
        uint32 used = BombUsed.get(player);
        BombUsed.set(player, used > 0 ? used - 1 : 0);

        Bomb.set(bomb, false);
        Position.set(bomb, 0, 0);
        PlacedBy.set(bomb, bytes32(0));
        TileLookup.set(session, tileX, tileY, EntityType.Bomb, bytes32(0));

        uint32 range = BombRange.get(bomb);
        bool megaBombPowerup = false; // tODO

        LibBomb.Destruction[] memory tilesToUpdate =
            LibBomb.getExplodedTiles(map, tileX, tileY, range, megaBombPowerup);

        for (uint256 i; i < tilesToUpdate.length; i++) {
            uint32 updateX = tilesToUpdate[i].x;
            uint32 updateY = tilesToUpdate[i].y;
            if (updateX == 0 && updateY == 0) continue;
            if (isUndestructable(tilesToUpdate[i].tile)) continue;

            map = LibTilemap.putTile(map, updateX, updateY, TileType.Grass);

            // generate random powerup if wall
            if (tilesToUpdate[i].tile == TileType.Wall) {
                (rng, map) = LibTilemap.generatePowerup(map, updateX, updateY, rng);
                continue;
            }

            bytes32 player = TileLookup.get(session, updateX, updateY, EntityType.Player);
            if (player != bytes32(0)) {
                Player.set(player, false);
                Position.set(player, 0, 0);
                TileLookup.set(session, updateX, updateY, EntityType.Player, bytes32(0));
            }

            bytes32 nextBomb = TileLookup.get(session, updateX, updateY, EntityType.Bomb);
            if (nextBomb != bytes32(0)) {
                (rng, map) = _triggerBomb(session, nextBomb, updateX, updateY, rng, map);
            }
        }
    }
}
