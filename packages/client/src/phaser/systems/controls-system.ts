import { Direction } from "@/types";
import { PhaserLayer } from "../create-phaser-layer";
import { getComponentValue, defineEnterSystem, Has } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";

export function createControlSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: { input },
    },
    network: {
      world,
      playerEntity,
      components: { LocalSession, SessionOf },
      systemCalls: { spawn, move, placeBomb, batchMove },
    },
  } = layer;

  defineEnterSystem(world, [Has(SessionOf)], ({ entity }) => {
    console.log({ entity, playerEntity });
    if (entity !== playerEntity) return;

    const session = getComponentValue(SessionOf, entity);
    const localSession = getComponentValue(LocalSession, singletonEntity);

    if (!session || !localSession || session.value !== localSession.id) return;

    // input.pointerdown$.subscribe((event) => {
    //   if (!event.pointer.leftButtonDown()) return;

    //   const { x, y } = pixelCoordToTileCoord(
    //     { x: event.pointer.worldX, y: event.pointer.worldY },
    //     TILE_WIDTH,
    //     TILE_HEIGHT
    //   );

    //   spawn(x, y);
    // });

    const dash = (direction: Direction, n: number) =>
      batchMove(Array(n).fill(direction));

    input.onKeyPress(
      (key) => key.has("SPACE"),
      () => spawn()
    );

    input.onKeyPress(
      (key) => key.has("UP") && key.has("Z"),
      () => dash(Direction.Up, 4)
    );
    input.onKeyPress(
      (key) => key.has("LEFT") && key.has("Z"),
      () => dash(Direction.Left, 4)
    );
    input.onKeyPress(
      (key) => key.has("DOWN") && key.has("Z"),
      () => dash(Direction.Down, 4)
    );
    input.onKeyPress(
      (key) => key.has("RIGHT") && key.has("Z"),
      () => dash(Direction.Right, 4)
    );

    input.onKeyPress(
      (key) => key.has("UP") && !key.has("Z"),
      () => move(Direction.Up)
    );
    input.onKeyPress(
      (key) => key.has("LEFT") && !key.has("Z"),
      () => move(Direction.Left)
    );
    input.onKeyPress(
      (key) => key.has("DOWN") && !key.has("Z"),
      () => move(Direction.Down)
    );
    input.onKeyPress(
      (key) => key.has("RIGHT") && !key.has("Z"),
      () => move(Direction.Right)
    );

    input.onKeyPress(
      (key) => key.has("X"),
      () => placeBomb()
    );
  });
}
