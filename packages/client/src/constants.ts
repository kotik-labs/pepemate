import { Entity } from "@latticexyz/recs";
import { TileAnimationKey, Tileset } from "./artTypes/world";
import { Animations, Direction, Sprites } from "./types";
import { Key } from "@latticexyz/phaserx";

export const ZERO_ENTITY =
  "0x0000000000000000000000000000000000000000000000000000000000000000" as Entity;

export const ANIMATION_INTERVAL = 80 * 8;
export const TILE_ANIMATION_INTERVAL = 80;
export const TILE_HEIGHT = 16;
export const TILE_WIDTH = 16;
export const MAX_WIDTH = 15;
export const MAX_HEIGHT = 15;
export const DEFAULT_SCALE = 2.6;

export const MAX_TICKS_PER_BLOCK = 70;
export const MAX_TICK_BLOCK_DELAY = 1;

export const INPUTS = ["up", "down", "left", "right", "primary", "secondary"] as const;
export type Inputs = (typeof INPUTS)[number];

export const DEFAULT_KEYBINDINGS: Record<Inputs, Key> = {
  up: "W",
  down: "S",
  left: "A",
  right: "D",
  primary: "J",
  secondary: "I",
};

export const DIR_LOOKUP = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
] as const;

export const TILESET = [
  Tileset.Void,
  Tileset.Grass,
  Tileset.Block,
  Tileset.Wall,
  Tileset.RangeUp,
  Tileset.SpeedUp,
  Tileset.BombsUp,

  Tileset.Spawner,
  Tileset.Spawner,
  Tileset.Spawner,
  Tileset.Spawner,
] as const;

export const AnimatedTiles: Partial<Record<Tileset, TileAnimationKey>> = {
  [Tileset.Bomb]: TileAnimationKey.Bomb,
  [Tileset.Spawner]: TileAnimationKey.Spawner,
  [Tileset.RangeUp]: TileAnimationKey.RangeUp,
  [Tileset.SpeedUp]: TileAnimationKey.SpeedUp,
  [Tileset.BombsUp]: TileAnimationKey.BombsUp,
};

export const MOCK_SESSION =
  "0x1234000000000000000000000000000000000000000000000000000000000000";

export const PlayerAnimationsLookup = {
  [Sprites.PlayerA]: {
    [Direction.Up]: Animations.PlayerAUp,
    [Direction.Down]: Animations.PlayerADown,
    [Direction.Left]: Animations.PlayerALeft,
    [Direction.Right]: Animations.PlayerARight,
  },
  [Sprites.PlayerB]: {
    [Direction.Up]: Animations.PlayerBUp,
    [Direction.Down]: Animations.PlayerBDown,
    [Direction.Left]: Animations.PlayerBLeft,
    [Direction.Right]: Animations.PlayerBRight,
  },
  [Sprites.PlayerC]: {
    [Direction.Up]: Animations.PlayerCUp,
    [Direction.Down]: Animations.PlayerCDown,
    [Direction.Left]: Animations.PlayerCLeft,
    [Direction.Right]: Animations.PlayerCRight,
  },
  [Sprites.PlayerD]: {
    [Direction.Up]: Animations.PlayerDUp,
    [Direction.Down]: Animations.PlayerDDown,
    [Direction.Left]: Animations.PlayerDLeft,
    [Direction.Right]: Animations.PlayerDRight,
  },
} as const;
