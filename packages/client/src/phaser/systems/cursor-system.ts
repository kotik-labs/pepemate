import {
  defineComponentSystem,
  getComponentValue,
  setComponent,
} from "@latticexyz/recs";
import { PhaserLayer } from "../create-phaser-layer";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { pixelCoordToTileCoord } from "@latticexyz/phaserx";
import { TILE_WIDTH, TILE_HEIGHT } from "@/constants";
// import { drawRect } from "@/lib/drawing";

export function createCursor(layer: PhaserLayer) {
  const {
    scenes: { Main },
    network: {
      world,
      components: { Cursor },
    },
  } = layer;

  // const { objectPool, input } = Main;
  const { input } = Main;

  // Updates the stored cursor (tile) position
  input.pointermove$.subscribe((event) => {
    const { x: xOld, y: yOld } = getComponentValue(Cursor, singletonEntity) ?? {
      x: 0,
      y: 0,
    };

    const { x: xNew, y: yNew } = pixelCoordToTileCoord(
      { x: event.pointer.worldX, y: event.pointer.worldY },
      TILE_WIDTH,
      TILE_HEIGHT
    );

    if (xNew === xOld && yNew === yOld) {
      return;
    }

    setComponent(Cursor, singletonEntity, { x: xNew, y: yNew });
  });

  // Draws the cursor rect
  defineComponentSystem(world, Cursor, ({ value }) => {
    const newCursorPosition = value[0];
    if (!newCursorPosition) return;

    // drawRect(objectPool, "CursorRect", newCursorPosition, 0xfafafa, 0.33);
  });
}
