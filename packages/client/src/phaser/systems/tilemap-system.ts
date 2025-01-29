import { defineSystem, getComponentValue, Has } from "@latticexyz/recs";
import { PhaserLayer } from "../create-phaser-layer";
import { positionToIndex } from "@/lib/game/grid-map";
import { toBytes } from "viem";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { AnimatedTiles, MAX_HEIGHT, MAX_WIDTH, TILESET } from "@/constants";

export function createTilemapSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: {
        maps: {
          Main: { putAnimationAt, removeAnimationAt, putTileAt },
        },
      },
    },
    network: {
      world,
      components: { SessionState, LocalSession },
    },
  } = layer;

  defineSystem(world, [Has(SessionState)], ({ entity, value }) => {
    const localSession = getComponentValue(LocalSession, singletonEntity);
    const session = value[0];

    if (!session || !localSession || localSession.id !== entity) return;

    const tileMap = toBytes(session.map as string);

    for (let y = 0; y < MAX_HEIGHT; y++) {
      for (let x = 0; x < MAX_WIDTH; x++) {
        const coord = { x, y };
        const index = tileMap[positionToIndex(x, y, MAX_WIDTH, MAX_HEIGHT)];
        const tile = TILESET[index];

        if (tile === undefined) continue;

        removeAnimationAt(coord, "Background");
        const animatedTile = AnimatedTiles[tile];

        if (animatedTile) {
          putAnimationAt(coord, animatedTile, "Background");
        } else {
          putTileAt(coord, tile, "Background");
        }
      }
    }
  });
}

/// matchmaking system
/// userA/B/C/D search for game (need to wait 5-10 blocks before bundling)
/// if their rating gap is small - bundle session with them
///
