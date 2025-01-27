import { Tileset } from "@/artTypes/world";
import { Coord } from "@latticexyz/phaserx";
import { DIR_LOOKUP, MAX_HEIGHT, MAX_WIDTH, TILESET } from "@/constants";
import { positionToIndex } from "./grid-map";
import { Animations } from "@/types";

export type Destruction = {
  animation: Animations;
  tileCoord: Coord;
};

export const getExplosionAnimations = (
  tileMap: Uint8Array,
  tileX: number,
  tileY: number,
  range: number
): Destruction[] => {
  const tiles: Destruction[] = [
    {
      animation: Animations.ExplosionCenter,
      tileCoord: { x: tileX, y: tileY },
    },
  ];

  for (const [dx, dy] of DIR_LOOKUP) {
    for (let i = 1; i <= range; i++) {
      const xi = tileX + dx * i;
      const yi = tileY + dy * i;
      const corner = i === range;
      const vertical = dx === 0;

      const index = tileMap[positionToIndex(xi, yi, MAX_WIDTH, MAX_HEIGHT)];
      if (TILESET[index] == Tileset.Block) break;
      if (TILESET[index] == Tileset.Wall) {
        tiles.push({
          animation: Animations.WallDestroy,
          tileCoord: { x: xi, y: yi },
        });
        break;
      }

      let animationKey;

      if (vertical) {
        animationKey = !corner
          ? Animations.ExplosionVertical
          : dy === -1
            ? Animations.ExplosionUp
            : Animations.ExplosionDown;
      } else {
        animationKey = !corner
          ? Animations.ExplosionHorizontal
          : dx === -1
            ? Animations.ExplosionLeft
            : Animations.ExplosionRight;
      }

      tiles.push({
        animation: animationKey,
        tileCoord: { x: xi, y: yi },
      });
    }
  }

  return tiles;
};
