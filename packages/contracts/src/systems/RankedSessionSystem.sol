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

// TODO
contract RankedSessionSystem is System {
    
}
