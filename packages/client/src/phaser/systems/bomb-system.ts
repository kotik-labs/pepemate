import {
  defineSystem,
  getComponentValue,
  Has,
  UpdateType,
  Entity,
} from "@latticexyz/recs";
import { PhaserLayer } from "../create-phaser-layer";
import { TileAnimationKey, Tileset } from "@/artTypes/world";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { drawAnimation } from "@/lib/game/drawing";
import { getExplosionAnimations } from "@/lib/game/bomb";
import { toBytes } from "viem";
import { uuid } from "@latticexyz/utils";
import { MAX_WIDTH } from "@/constants";

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
      components: {
        SessionMap,
        EntitySession,
        LocalSession,
        BombIndex,
        BombRange,
      },
    },
  } = layer;

  defineSystem(
    world,
    [Has(BombIndex), Has(EntitySession)],
    ({ entity, value, type, component }) => {
      const localSession = getComponentValue(LocalSession, singletonEntity);
      if (!localSession) return;

      const session = getComponentValue(EntitySession, entity);
      if (!session || session.session !== localSession.id) return;

      const sessionData = getComponentValue(
        SessionMap,
        session.session as Entity
      );
      if (!sessionData) return;

      const tileMap = toBytes(sessionData.terrain);
      
      if (type === UpdateType.Exit && component.id == BombIndex.id) {
        console.log("BOMB DETONATED", { entity, value, type });
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const bombIndex = value[1] as any;
        const power = getComponentValue(BombRange, entity);
        if (!power) return;

        // const bombTile = pixelCoordToTileCoord(
        //   position,
        //   TILE_WIDTH,
        //   TILE_HEIGHT
        // );
        const bombTile = {
          x: bombIndex.index % MAX_WIDTH,
          y: Math.floor(bombIndex.index / MAX_WIDTH),
        };

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

      if (type === UpdateType.Update || type === UpdateType.Enter) {
        const bombIndex = getComponentValue(BombIndex, entity);
        if (!bombIndex || bombIndex.index == 0) return;

        console.log("BOMB PLACED", { entity, value, type, component });

        const tileCoord = {
          x: bombIndex.index % MAX_WIDTH,
          y: Math.floor(bombIndex.index / MAX_WIDTH),
        };

        putAnimationAt(tileCoord, TileAnimationKey.Bomb, "Foreground");
      }
    }
  );
}
