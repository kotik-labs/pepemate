import { Direction } from "@/types";

export const applyDirection = (
  x: number,
  y: number,
  dir: Direction,
  speed: number
): [number, number] => {
  const dy = dir === Direction.Up ? -speed : dir === Direction.Down ? speed : 0;
  const dx =
    dir === Direction.Left ? -speed : dir === Direction.Right ? speed : 0;

  return [x + dx, y + dy];
};

export const indexToPosition = (
  index: number,
  width: number,
  height: number
) => {
  if (index < 0 || index >= width * height)
    throw new Error("Index out of bounds");

  return { x: index % width, y: Math.floor(index / width) };
};

export const positionToIndex = (
  x: number,
  y: number,
  width: number,
  height: number
) => {
  if (x < 0 || y < 0 || x >= width || y >= height)
    throw new Error("Coordinates are out of bounds");

  return y * width + x;
};
