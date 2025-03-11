// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {MatchLookup, EntityMatch, MatchPlayers, MatchConfig, MatchTerrain, Map, InQueue} from "../codegen/index.sol";
import {fillWalls} from "../libraries/LibTilemap.sol";
import {bytesEq} from "../libraries/LibUtils.sol";
import {Entity} from "../Entity.sol";
import {createEntity} from "../createEntity.sol";

function playerInMatch(address playerAddress) view returns (bool) {
    (Entity matchEntity, Entity player) = MatchLookup.get(playerAddress);
    return !matchEntity.isEmpty() && !player.isEmpty();
}

function checkMatchmaking(
    address[4] memory addressesInQueue,
    Entity mapExpected,
    uint256 queueDelay,
    uint256 ratingDiff
) view returns (bool) {
    for (uint256 i; i < 4; i++) {
        address player = addressesInQueue[i];

        (uint32 startBlock, Entity map) = InQueue.get(player);
        require(startBlock != 0 && !map.isEmpty(), "Player isn't in-queue");
        require(mapExpected.equals(map), "Invalid Map");

        uint256 elapsedBlocks = block.number > startBlock ? (block.number - startBlock) : 0;
        require(elapsedBlocks >= queueDelay, "Invalid queue time");
        // TODO: rating check
    }

    return true;
}

function joinQueue(address player, Entity mapEntity) {
    (uint32 startBlock, Entity map) = InQueue.get(player);
    require(startBlock == 0 && map.isEmpty(), "Player in-queue already");
    InQueue.set(player, uint32(block.number), mapEntity);
}

function leaveQueue(address player) {
    (uint32 startBlock, Entity map) = InQueue.get(player);
    require(startBlock != 0 && !map.isEmpty(), "Player isn't in-queue");
    InQueue.deleteRecord(player);
}

function createPlayer(address owner, Entity matchEntity) returns (Entity playerEntity) {
    leaveQueue(owner);

    playerEntity = createEntity();
    EntityMatch.set(playerEntity, matchEntity);
    MatchLookup.set(owner, matchEntity, playerEntity);
}

function createMatch(
    Entity mapEntity,
    address[4] memory addressesInQueue,
    uint32 maxWalls,
    uint32 queueDelay,
    uint32 ratingDiff
) {
    require(checkMatchmaking(addressesInQueue, mapEntity, queueDelay, ratingDiff), "Ivalid matchmaking");

    bytes memory terrain = Map.getTerrain(mapEntity);
    require(!bytesEq(terrain, hex""), "no map found");

    terrain = fillWalls(terrain, maxWalls, block.prevrandao);

    uint32 initBlock = uint32(block.number);
    Entity matchEntity = createEntity();
    MatchConfig.set(matchEntity, initBlock, initBlock, mapEntity);
    MatchTerrain.set(matchEntity, terrain);

    bytes32[4] memory players;
    for (uint256 i; i < 4; i++) {
        players[i] = createPlayer(addressesInQueue[i], matchEntity).unwrap();
    }
    MatchPlayers.set(matchEntity, players);
}
