// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibUtils, LibBitmap, LibPlayer, LibTilemap, LibTile, LibTick} from "../libraries/Libraries.sol";
import {Direction, SessionType, EntityType} from "../codegen/common.sol";
import {
    Player, Position, SessionPlayers, Map, SessionMap, Session, EntitySession, TileLookup
} from "../codegen/index.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF} from "../constants.sol";
import {Entity} from "../Entity.sol";


contract PublicSessionSystem is System {
    function createPublic(uint256 id, Entity map) public returns (Entity session) {
        bytes memory terrain = Map.getTerrain(map);
        require(!LibUtils.bytesEq(terrain, hex""), "no map found");

        // TODO: remove it
        session = Entity.wrap(keccak256(abi.encode(id)));
        terrain = LibTilemap.fillWalls(terrain, 50, uint256(session.unwrap()));

        Session.set(session, SessionType.Public);
        SessionMap.set(session, map, terrain);
    }

    function joinPublic(Entity session, uint8 playerIndex) public {
        Entity entity = LibPlayer.entityKey(_msgSender());

        require(playerIndex < 4, "Invalid input");
        require(Session.get(session) == SessionType.Public, "Not a public session");
        require(EntitySession.get(entity).isEmpty(), "Player already in-game");

        bytes32[4] memory players = SessionPlayers.get(session);
        require(players[playerIndex] == bytes32(0), "This player index is already locked");

        players[playerIndex] = entity.unwrap();
        SessionPlayers.set(session, players);
        EntitySession.set(entity, session);
        LibTick.update(entity, 0);
    }

    function leavePublic() public {
        Entity entity = LibPlayer.entityKey(_msgSender());
        Entity session = EntitySession.get(entity);

        require(!session.isEmpty(), "Player is not in-game");
        require(Session.get(session) == SessionType.Public, "Not a public session");

        bytes32[4] memory players = SessionPlayers.get(session);
        (bool found, uint256 playerIndex) = LibPlayer.playerIndex(entity, players);
        require(found, "Player not found in session");

        players[playerIndex] = bytes32(0);
        SessionPlayers.set(session, players);

        (uint32 x, uint32 y) = Position.get(entity);

        Player.deleteRecord(entity);
        Position.deleteRecord(entity);
        EntitySession.deleteRecord(entity);
        TileLookup.deleteRecord(session, LibTile.getTileIndex(x, y), EntityType.Player);
    }
}
