// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {coordToIndex, indexToCoord} from "./LibTile.sol";
import {getTile} from "./LibTilemap.sol";
import {TileType} from "../codegen/common.sol";
import {BASE_SPEED, DIR_COUNT, MAX_WIDTH, MAX_HEIGHT} from "../constants.sol";
import {Entity} from "../Entity.sol";

struct Destruction {
    TileType tile;
    uint32 index;
}

function isUndestructable(TileType t) pure returns (bool) {
    return t == TileType.SpawnA || t == TileType.SpawnB || t == TileType.SpawnC || t == TileType.SpawnD;
}

function getExplodedTiles(bytes memory map, uint32 tileIndex, uint32 range, bool megaBomb)
    pure
    returns (Destruction[] memory tiles)
{
    uint256 index = 0;
    tiles = new Destruction[](1 + range * DIR_COUNT);
    tiles[index++] = Destruction(getTile(map, tileIndex), tileIndex);

    (uint32 tileX, uint32 tileY) = indexToCoord(tileIndex, MAX_WIDTH, MAX_HEIGHT);
    for (uint32 dir = 0; dir < DIR_COUNT; dir++) {
        for (uint32 i = 1; i <= range; i++) {
            uint32 tileIndex_;

            if (dir == 0 || dir == 1) {
                tileIndex_ = coordToIndex(tileX, dir == 0 ? (tileY > i ? tileY - i : 0) : tileY + i, MAX_WIDTH);
            } else {
                tileIndex_ = coordToIndex(dir == 2 ? (tileX > i ? tileX - i : 0) : tileX + i, tileY, MAX_WIDTH);
            }

            TileType t = getTile(map, tileIndex_);

            if (t == TileType.Block) break;
            if (t == TileType.Wall && !megaBomb) {
                tiles[index++] = Destruction(t, tileIndex_);
                break;
            }
            tiles[index++] = Destruction(t, tileIndex_);
        }
    }
}

