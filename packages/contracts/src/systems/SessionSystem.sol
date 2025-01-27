// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibUtils, LibBitmap, LibPlayer, LibTilemap} from "../libraries/Libraries.sol";
import {Direction, SessionStatus, TeamMode, GameMode, EntityType} from "../codegen/common.sol";
import {
    Player,
    Position,
    Session,
    SessionData,
    Map,
    SessionOf,
    PlayerIndex,
    TileLookup
} from "../codegen/index.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF} from "../constants.sol";

contract SessionSystem is System {
    function createSession(bytes32 id, GameMode gameMode, TeamMode teamMode, bytes32 map)
        public
    {
        (uint32[4] memory spawnIndexes, bytes memory terrain) = Map.get(map);
        require(!LibUtils.bytesEq(terrain, hex""), "no map found");

        SessionData memory session = SessionData({
            status: SessionStatus.InLobby,
            gameMode: gameMode,
            teamMode: teamMode,
            spawnIndexes: spawnIndexes,
            playerBitmap: uint8(0),
            map: terrain
        });

        Session.set(id, session);
    }

    function joinSession(bytes32 session, uint8 playerIndex) public {
        require(session != bytes32(0) && playerIndex < 4, "Invalid input");

        bytes32 entity = LibPlayer.entityKey(_msgSender());
        require(SessionOf.get(entity) == bytes32(0), "Player already in-game");

        uint8 playerBitmap = Session.getPlayerBitmap(session);
        bool positionLocked = LibBitmap.get(playerBitmap, playerIndex);
        require(!positionLocked, "This player index is alredy locked");

        Session.setPlayerBitmap(session, uint8(LibBitmap.set(playerBitmap, playerIndex)));
        SessionOf.set(entity, session);
        PlayerIndex.set(entity, playerIndex);
    }

    function leaveSession() public {
        bytes32 entity = LibPlayer.entityKey(_msgSender());
        bytes32 session = SessionOf.get(entity);
        require(session != bytes32(0), "Player is not in-game");

        uint8 playerBitmap = Session.getPlayerBitmap(session);
        uint8 playerIndex = PlayerIndex.get(entity);
        Session.setPlayerBitmap(
            session, uint8(LibBitmap.reset(playerBitmap, playerIndex))
        );

        (uint32 x, uint32 y) = Position.get(entity);
        (uint32 tileX, uint32 tileY) = LibTilemap.getTileCoord(x, y);

        Player.set(entity, false);
        Position.set(entity, 0, 0);
        SessionOf.set(entity, bytes32(0));
        PlayerIndex.set(entity, 0);
        TileLookup.set(session, tileX, tileY, EntityType.Player, bytes32(0));
    }
}
