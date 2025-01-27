// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {TileType, Direction} from "./codegen/common.sol";

uint32 constant MAX_TICKS_PER_BLOCK = 12;
uint32 constant MAX_TICK_BLOCK_DELAY = 1;

uint32 constant MOVE_COST = 1;
uint32 constant PLANT_BOMB_COST = 2;

uint32 constant MAX_WIDTH = 15;
uint32 constant MAX_HEIGHT = 15;
uint32 constant TILE_SIZE = 16;
uint32 constant TILE_HALF = TILE_SIZE / 2;

uint32 constant MAX_PLAYERS = 4;
uint32 constant BASE_SPEED = 4;
uint32 constant BASE_BOMB_COUNT = 1;
uint32 constant BASE_BOMB_RANGE = 2;
uint256 constant FUSE_BLOCK_DELAY = 1;

uint256 constant TILE_COUNT = uint256(type(TileType).max) + 1;
uint256 constant DIR_COUNT = uint256(type(Direction).max) + 1;
