// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {coordToIndex} from "./LibTile.sol";
import {TileType} from "../codegen/common.sol";
import {MAX_WIDTH, MAX_HEIGHT} from "../constants.sol";

function rngSeed() view returns (uint256 nextRng) {
    nextRng = uint256(block.prevrandao);
}

function rngNext(uint256 rng) pure returns (uint256 nextRng) {
    nextRng = uint256(keccak256(abi.encode(rng)));
}

function rngRange(uint256 rng, uint256 minValue, uint256 maxValue) pure returns (uint256 nextRng, uint256 val) {
    nextRng = rngNext(rng);
    val = minValue + nextRng % maxValue;
}

function rngSample(uint256 rng, uint256[] memory weights) pure returns (uint256, uint256) {
    uint256 cumulativeWeight;
    uint256 totalWeight;
    uint256 weightsLength = weights.length;
    uint256 randVal;

    for (uint256 i = 0; i < weightsLength; i++) {
        totalWeight += weights[i];
    }

    (rng, randVal) = rngRange(rng, 0, totalWeight);

    for (uint256 i = 0; i < weightsLength; i++) {
        cumulativeWeight += weights[i];
        if (randVal < cumulativeWeight) return (rng, i);
    }

    return (rng, weightsLength - 1);
}

/**
 * @dev Checks equality of two strings
 */
function stringEq(string memory a, string memory b) pure returns (bool) {
    return bytesEq(bytes(a), bytes(b));
}

/**
 * @dev Checks equality of two strings
 */
function bytesEq(bytes memory a, bytes memory b) pure returns (bool) {
    return a.length == b.length ? keccak256(a) == keccak256(b) : false;
}

function pack(TileType[MAX_WIDTH][MAX_HEIGHT] memory data)
    pure
    returns (uint32[4] memory spawnIndexes, bytes memory tileMap)
{
    tileMap = new bytes(MAX_WIDTH * MAX_HEIGHT);

    for (uint32 y = 0; y < MAX_HEIGHT; y++) {
        for (uint32 x = 0; x < MAX_WIDTH; x++) {
            TileType tile = data[y][x];
            uint32 index = coordToIndex(x, y, MAX_WIDTH);
            // TODO; redo it, spawn tile doesn't make sense
            if (tile == TileType.SpawnA) {
                spawnIndexes[0] = index;
            }

            if (tile == TileType.SpawnB) {
                spawnIndexes[1] = index;
            }

            if (tile == TileType.SpawnC) {
                spawnIndexes[2] = index;
            }

            if (tile == TileType.SpawnD) {
                spawnIndexes[3] = index;
            }

            tileMap[index] = bytes1(uint8(tile));
        }
    }
}
