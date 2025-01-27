// GENERATED CODE - DO NOT MODIFY BY HAND

export enum Tileset {
  Grass = 0,
  Block = 1,
  Border = 2,
  Wall = 3,
  Bomb = 4,
  Void = 7,
  SpeedUp = 8,
  Spawner = 10,
  RangeUp = 12,
  BombsUp = 14,
}
export enum TileAnimationKey {
  Bomb = "Bomb",
  SpeedUp = "SpeedUp",
  Spawner = "Spawner",
  RangeUp = "RangeUp",
  BombsUp = "BombsUp",
}
export const TileAnimations: { [key in TileAnimationKey]: number[] } = {
  [TileAnimationKey.Bomb]: [4, 5, 6],
  [TileAnimationKey.SpeedUp]: [8, 9],
  [TileAnimationKey.Spawner]: [10, 11],
  [TileAnimationKey.RangeUp]: [12, 13],
  [TileAnimationKey.BombsUp]: [14, 15],
};
