// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTile} from "./LibTile.sol";
import {LibTilemap} from "./LibTilemap.sol";
import {TileType} from "../codegen/common.sol";
import {BASE_SPEED, DIR_COUNT} from "../constants.sol";
import {Entity} from "../Entity.sol";

library LibBomb {
    struct Destruction {
        TileType tile;
        uint32 index;
    }

    function entityKey(Entity session, uint32 tileIndex) internal pure returns (Entity) {
        return Entity.wrap(keccak256(abi.encode(session, tileIndex)));
    }

    function isUndestructable(TileType t) internal pure returns (bool) {
        return t == TileType.SpawnA || t == TileType.SpawnB || t == TileType.SpawnC || t == TileType.SpawnD;
    }

    function getExplodedTiles(bytes memory map, uint32 tileIndex, uint32 range, bool megaBomb)
        internal
        pure
        returns (Destruction[] memory tiles)
    {
        uint256 index = 0;
        tiles = new Destruction[](1 + range * DIR_COUNT);
        tiles[index++] = Destruction(LibTilemap.getTile(map, tileIndex), tileIndex);

        (uint32 tileX, uint32 tileY) = LibTile.indexToCoord(tileIndex);
        for (uint32 dir = 0; dir < DIR_COUNT; dir++) {
            for (uint32 i = 1; i <= range; i++) {
                uint32 tileIndex_;

                if (dir == 0 || dir == 1) {
                    tileIndex_ = LibTile.coordToIndex(tileX, dir == 0 ? (tileY > i ? tileY - i : 0) : tileY + i);
                } else {
                    tileIndex_ = LibTile.coordToIndex(dir == 2 ? (tileX > i ? tileX - i : 0) : tileX + i, tileY);
                }

                TileType t = LibTilemap.getTile(map, tileIndex_);

                if (t == TileType.Block) break;
                if (t == TileType.Wall && !megaBomb) {
                    tiles[index++] = Destruction(t, tileIndex_);
                    break;
                }
                tiles[index++] = Destruction(t, tileIndex_);
            }
        }
    }
}
