import {
  defineSystem,
  getComponentValue,
  Has,
  HasValue,
  UpdateType,
  Entity,
} from "@latticexyz/recs";
import { PhaserLayer } from "../create-phaser-layer";
import { TileAnimationKey, Tileset } from "@/artTypes/world";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { drawAnimation } from "@/lib/game/drawing";
import { getExplosionAnimations } from "@/lib/game/bomb";
import { Hex, toBytes } from "viem";
import { uuid } from "@latticexyz/utils";

export function createBombSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: {
        objectPool,
        maps: {
          Main: { putAnimationAt, removeAnimationAt, putTileAt },
        },
      },
    },
    network: {
      world,
      systemCalls: { triggerBomb },
      components: {
        Session,
        SessionOf,
        LocalSession,
        Bomb,
        Position,
        BombRange,
      },
    },
  } = layer;

  defineSystem(
    world,
    [HasValue(Bomb, { value: true }), Has(Position), Has(SessionOf)],
    ({ entity, value, type }) => {
      const localSession = getComponentValue(LocalSession, singletonEntity);
      if (!localSession) return;

      const session = getComponentValue(SessionOf, entity);
      if (!session || session.value !== localSession.id) return;

      const sessionData = getComponentValue(Session, session.value as Entity);
      if (!sessionData) return;

      const tileMap = toBytes(sessionData.map);

      if (type === UpdateType.Update || type === UpdateType.Enter) {
        console.log("BOMB PLACED", { entity, value, type });
        const position = getComponentValue(Position, entity);
        if (!position || (position.x === 0 && position.y === 0)) return;

        putAnimationAt(
          // pixelCoordToTileCoord(position, TILE_WIDTH, TILE_HEIGHT),
          position,
          TileAnimationKey.Bomb,
          "Foreground"
        );

        setTimeout(() => {
          triggerBomb(session.value as Hex, position.x, position.y);
          triggerBomb(session.value as Hex, position.x, position.y);
          triggerBomb(session.value as Hex, position.x, position.y);
        }, 3000);
      }

      if (type === UpdateType.Exit) {
        console.log("BOMB DETONATED", { entity, value, type });
        const power = getComponentValue(BombRange, entity);
        const position = getComponentValue(Position, entity);
        if (!position || !power) return;

        // const bombTile = pixelCoordToTileCoord(
        //   position,
        //   TILE_WIDTH,
        //   TILE_HEIGHT
        // );

        const bombTile = position;

        removeAnimationAt(bombTile, "Foreground");
        putTileAt(bombTile, Tileset.Void, "Foreground");

        for (const { animation, tileCoord } of getExplosionAnimations(
          tileMap,
          bombTile.x,
          bombTile.y,
          power.value
        )) {
          drawAnimation(objectPool, uuid(), animation, tileCoord);
        }
      }
    }
  );
}
