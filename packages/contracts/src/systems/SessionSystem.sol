// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {LibUtils, LibBitmap, LibPlayer, LibTilemap, LibTile} from "../libraries/Libraries.sol";
import {Direction, SessionStatus, EntityType} from "../codegen/common.sol";
import {
    Player,
    Position,
    SessionState,
    SessionStateData,
    Map,
    Session,
    PlayerIndex,
    TileLookup
} from "../codegen/index.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF} from "../constants.sol";
import {Entity} from "../Entity.sol";

/*
Session:
flow:
"Create Session" on sessions page
select map + amount of blocks placed + min bet to enter
when 4 players joined - call start game with vesting 10 secs
if user leaves - he loss his bet
every player have 3 lifes per match
"dead" players can still interact with game, to eliminate other players and receive liquidation fee
when one user is alive - trigger "resolveSession"
when session resolved - redistribute eth to players
*/

contract SessionSystem is System {
    function createSession(uint256 id, bytes32 mapId) public returns (Entity session) {
        (uint32[4] memory spawnIndexes, bytes memory terrain) = Map.get(mapId);
        require(!LibUtils.bytesEq(terrain, hex""), "no map found");

        // TODO: remove it
        session = Entity.wrap(keccak256(abi.encode(id)));
        terrain = LibTilemap.fillWalls(spawnIndexes, terrain, 50, uint256(session.unwrap()));

        SessionStateData memory state = SessionStateData({
            status: SessionStatus.InLobby,
            spawnIndexes: spawnIndexes,
            playerBitmap: uint8(0),
            map: terrain
        });

        SessionState.set(session, state);
    }

    function joinSession(Entity session, uint8 playerIndex) public {
        Entity entity = LibPlayer.entityKey(_msgSender());

        require(!session.isEmpty() && playerIndex < 4, "Invalid input");
        require(Session.get(entity).isEmpty(), "Player already in-game");

        uint8 playerBitmap = SessionState.getPlayerBitmap(session);
        require(!LibBitmap.get(playerBitmap, playerIndex), "This player index is already locked");
        SessionState.setPlayerBitmap(session, uint8(LibBitmap.set(playerBitmap, playerIndex)));

        Session.set(entity, session);
        // Owner.set(entity, _msgSender());
        PlayerIndex.set(entity, playerIndex);
    }

    function leaveSession() public {
        Entity entity = LibPlayer.entityKey(_msgSender());
        Entity session = Session.get(entity);

        // require(Owner.get(entity) == _msgSender(), "");
        require(!session.isEmpty(), "Player is not in-game");

        uint8 playerBitmap = SessionState.getPlayerBitmap(session);
        uint8 playerIndex = PlayerIndex.get(entity);
        SessionState.setPlayerBitmap(session, uint8(LibBitmap.reset(playerBitmap, playerIndex)));

        (uint32 x, uint32 y) = Position.get(entity);
        (uint32 tileIndex) = LibTile.getTileIndex(x, y);

        Player.set(entity, false);
        // Owner.set(entity, address(0));
        Position.set(entity, 0, 0);
        Session.set(entity, Entity.wrap(0));
        PlayerIndex.set(entity, 0);
        TileLookup.set(session, tileIndex, EntityType.Player, Entity.wrap(0));
    }
}
