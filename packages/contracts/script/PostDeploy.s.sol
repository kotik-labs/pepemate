// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Position, Map} from "../src/codegen/index.sol";
import {TileType} from "../src/codegen/common.sol";
import {LibUtils, LibTilemap} from "../src/libraries/Libraries.sol";
import {StoreSwitch} from "@latticexyz/store/src/StoreSwitch.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";

contract PostDeploy is Script {
    function run(address worldAddress) external {
        // Specify a store so that you can use tables directly in PostDeploy
        StoreSwitch.setStoreAddress(worldAddress);

        // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        TileType N = TileType.None;
        TileType W = TileType.Wall;

        TileType O = TileType.Grass;
        TileType X = TileType.Block;

        TileType A = TileType.SpawnA;
        TileType B = TileType.SpawnB;
        TileType C = TileType.SpawnC;
        TileType D = TileType.SpawnD;

        TileType[15][15] memory mapDataA = [
            [X, X, X, X, X, X, X, X, X, X, X, X, X, X, X],
            [X, A, O, O, O, O, O, O, O, O, O, O, O, C, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, O, O, O, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, O, O, O, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, O, O, O, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, O, O, O, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, O, O, O, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, O, X, O, X, O, X, O, X],
            [X, D, O, O, O, O, O, O, O, O, O, O, O, B, X],
            [X, X, X, X, X, X, X, X, X, X, X, X, X, X, X]
        ];

        TileType[15][15] memory mapDataB = [
            [X, X, X, X, X, X, X, X, X, X, X, X, X, X, X],
            [X, O, O, A, O, O, X, X, X, O, O, C, O, O, X],
            [X, O, X, O, X, O, X, X, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, X, X, X, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, X, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, X, X, X, O, O, O, O, O, X],
            [X, O, X, O, X, O, W, X, W, O, X, O, X, O, X],
            [X, O, O, X, O, O, W, W, W, O, O, X, O, O, X],
            [X, O, X, O, X, O, W, X, W, O, X, O, X, O, X],
            [X, O, O, O, O, O, X, X, X, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, X, X, O, X, O, X, O, X],
            [X, O, O, O, O, O, X, X, X, O, O, O, O, O, X],
            [X, O, X, O, X, O, X, X, X, O, X, O, X, O, X],
            [X, O, O, D, O, O, X, X, X, O, O, B, O, O, X],
            [X, X, X, X, X, X, X, X, X, X, X, X, X, X, X]
        ];

        (uint32[4] memory spawnIndexes, bytes memory terrain) = LibUtils.pack(mapDataA);
        bytes32 mapKey = LibTilemap.entityKey(terrain);

        // Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);
        // ---------------------------------------------------------
        Map.set(mapKey, spawnIndexes, terrain);

        IWorld(worldAddress).pepemate__createSession(1, mapKey);
        IWorld(worldAddress).pepemate__createSession(2, mapKey);
        IWorld(worldAddress).pepemate__createSession(3, mapKey);
        IWorld(worldAddress).pepemate__createSession(4, mapKey);
        IWorld(worldAddress).pepemate__createSession(5, mapKey);

        // ---------------------------------------------------------
        vm.stopBroadcast();
    }
}
