import { PhaserLayer } from "@/phaser/create-phaser-layer";
import { Coord } from "@latticexyz/utils";
import { tileCoordToPixelCoord } from "@latticexyz/phaserx";
import { TILE_HEIGHT, TILE_WIDTH } from "@/constants";
import { Animations } from "@/types";

type ObjectPool = PhaserLayer["scenes"]["Main"]["objectPool"];

export function drawRect(
  objectPool: ObjectPool,
  id: string,
  position: Coord,
  fillColor: number,
  fillAlpha = 0.4
) {
  objectPool.get(id, "Rectangle").setComponent({
    id,
    once: (gameObject) => {
      const pixelPosition = tileCoordToPixelCoord(
        position,
        TILE_WIDTH,
        TILE_HEIGHT
      );
      gameObject.setPosition(pixelPosition.x, pixelPosition.y);
      gameObject.setSize(TILE_WIDTH, TILE_HEIGHT);
      gameObject.setFillStyle(fillColor, fillAlpha);
    },
  });
}

export const drawAnimation = (
  objectPool: ObjectPool,
  id: string,
  animation: Animations,
  tileCoords: Coord
) => {
  objectPool.get(id, "Sprite").setComponent({
    id,
    once: (gameObject) => {
      const position = tileCoordToPixelCoord(
        tileCoords,
        TILE_WIDTH,
        TILE_HEIGHT
      );
      gameObject.setPosition(position.x, position.y);
      gameObject.play(animation, true);
    },
  });
};

export const drawPlayer = (
  objectPool: ObjectPool,
  id: string,
  coord: Coord,
  texture: any
) => {
  objectPool.get(id, "Sprite").setComponent({
    id: id,
    once: (gameObject) => {
      gameObject.setOrigin(0.5, 16 / 24);
      gameObject.setScale(1);
      gameObject.setTexture(texture.assetKey, texture.frame);
      gameObject.setPosition(coord.x, coord.y);
    },
  });
};
