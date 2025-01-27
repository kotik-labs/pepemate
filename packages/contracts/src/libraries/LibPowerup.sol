// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibUtils} from "./LibUtils.sol";
import {TILE_SIZE, BASE_SPEED, TILE_HALF, MAX_WIDTH} from "../constants.sol";
import {Direction, TileType} from "../codegen/common.sol";

library LibPowerup {
    function isPowerupTile(TileType t) internal pure returns (bool) {
        return t == TileType.RangeUp || t == TileType.BombsUp || t == TileType.SpeedUp;
    }

    function samplePowerup(uint256 rng) internal pure returns (uint256, TileType) {
        TileType[3] memory tiles =
            [TileType.Grass, TileType.RangeUp, TileType.BombsUp];
        uint256[3] memory weights = [uint256(50), uint256(25), uint256(25)];
        uint256 totalWeight = 100;

        uint256 cumulativeWeight;
        uint256 weightsLength = weights.length;
        uint256 randVal;

        // for (uint256 i = 0; i < weightsLength; i++) {
        //     totalWeight += weights[i];
        // }

        (rng, randVal) = LibUtils.rngRange(rng, 0, totalWeight);

        for (uint256 i = 0; i < weightsLength; i++) {
            cumulativeWeight += weights[i];
            if (randVal < cumulativeWeight) return (rng, tiles[i]);
        }

        return (rng, tiles[weightsLength - 1]);
    }
}
