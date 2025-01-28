import { Direction } from "@/types";
import { PhaserLayer } from "../create-phaser-layer";
import { getComponentValue, defineEnterSystem, Has } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { Key } from "@latticexyz/phaserx";

const INPUTS = ["Up", "Down", "Left", "Right", "Primary", "Secondary"] as const;
type Inputs = (typeof INPUTS)[number];

const KeyBindings: Record<Inputs, Key> = {
  Up: "UP",
  Down: "DOWN",
  Left: "LEFT",
  Right: "RIGHT",
  Primary: "Z",
  Secondary: "X",
};

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

    input.onKeyPress(
      (key) => Object.values(KeyBindings).some((k) => key.has(k)),
      () => spawn()
    );

    // UP movements
    input.onKeyPress(
      (key) => key.has(KeyBindings.Up) && key.has(KeyBindings.Secondary),
      () => batchMove(Direction.Up, 4)
    );
    input.onKeyPress(
      (key) => key.has(KeyBindings.Up) && !key.has(KeyBindings.Secondary),
      () => move(Direction.Up)
    );

    // LEFT movements
    input.onKeyPress(
      (key) => key.has(KeyBindings.Left) && key.has(KeyBindings.Secondary),
      () => batchMove(Direction.Left, 4)
    );
    input.onKeyPress(
      (key) => key.has(KeyBindings.Left) && !key.has(KeyBindings.Secondary),
      () => move(Direction.Left)
    );

    // DOWN movements
    input.onKeyPress(
      (key) => key.has(KeyBindings.Down) && key.has(KeyBindings.Secondary),
      () => batchMove(Direction.Down, 4)
    );
    input.onKeyPress(
      (key) => key.has(KeyBindings.Down) && !key.has(KeyBindings.Secondary),
      () => move(Direction.Down)
    );

    // RIGHT movements
    input.onKeyPress(
      (key) => key.has(KeyBindings.Right) && key.has(KeyBindings.Secondary),
      () => batchMove(Direction.Right, 4)
    );
    input.onKeyPress(
      (key) => key.has(KeyBindings.Right) && !key.has(KeyBindings.Secondary),
      () => move(Direction.Right)
    );

    // BOMB
    input.onKeyPress(
      (key) => key.has(KeyBindings.Primary),
      () => placeBomb()
    );
  });
}
