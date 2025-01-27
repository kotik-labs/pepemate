// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LibTilemap} from "./LibTilemap.sol";
import {TileType} from "../codegen/common.sol";
import {BASE_SPEED, DIR_COUNT} from "../constants.sol";

library LibBomb {
    struct Destruction {
        TileType tile;
        uint32 x;
        uint32 y;
    }

    function entityKey(bytes32 session, uint32 tileX, uint32 tileY)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(session, tileX, tileY));
    }

    function getExplodedTiles(
        bytes memory map,
        uint32 tileX,
        uint32 tileY,
        uint32 range,
        bool megaBomb
    ) internal pure returns (Destruction[] memory tiles) {
        uint256 index = 0;
        tiles = new Destruction[](1 + range * DIR_COUNT);
        tiles[index++] = Destruction(LibTilemap.getTile(map, tileX, tileY), tileX, tileY);

        for (uint32 dir = 0; dir < DIR_COUNT; dir++) {
            for (uint32 i = 1; i <= range; i++) {
                uint32 xi;
                uint32 yi;

                if (dir == 0 || dir == 1) {
                    xi = tileX;
                    yi = dir == 0 ? (tileY > i ? tileY - i : 0) : tileY + i;
                } else {
                    xi = dir == 2 ? (tileX > i ? tileX - i : 0) : tileX + i;
                    yi = tileY;
                }

                TileType t = LibTilemap.getTile(map, xi, yi);

                if (t == TileType.Block) break;
                if (t == TileType.Wall && !megaBomb) {
                    tiles[index++] = Destruction(t, xi, yi);
                    break;
                }
                tiles[index++] = Destruction(t, xi, yi);
            }
        }
    }
}
