import { Direction } from "@/types";
import { PhaserLayer } from "../create-phaser-layer";
import { getComponentValue, defineEnterSystem, Has } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { ANIMATION_INTERVAL } from "@/constants";
import { getBrowserControls } from "@/lib/utils";
import { Input } from "phaser";

let controlsInterval: ReturnType<typeof setInterval>;

export function createControlSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: { input, phaserScene },
    },
    network: {
      world,
      playerEntity,
      components: { LocalSession, MatchLookup },
      systemCalls: { spawn, move, placeBomb, batchMove },
    },
  } = layer;

  defineEnterSystem(world, [Has(MatchLookup)], ({ entity }) => {
    if (entity !== playerEntity) return;

    const session = getComponentValue(MatchLookup, entity);
    const localSession = getComponentValue(LocalSession, singletonEntity);

    if (!session || !localSession || session.matchEntity !== localSession.id)
      return;

    input.pointerdown$.subscribe((event) => {
      if (!event.pointer || !event.pointer.leftButtonDown()) return;
      spawn();
    });

    input.onKeyPress(
      (key) => {
        const controls = getBrowserControls();
        return key.has(controls.primary);
      },
      () => placeBomb()
    );
    input.onKeyPress(
      (key) => {
        const controls = getBrowserControls();
        return key.has(controls.up) && key.has(controls.secondary);
      },
      () => batchMove(Direction.Up, 4)
    );
    input.onKeyPress(
      (key) => {
        const controls = getBrowserControls();
        return key.has(controls.left) && key.has(controls.secondary);
      },
      () => batchMove(Direction.Left, 4)
    );
    input.onKeyPress(
      (key) => {
        const controls = getBrowserControls();
        return key.has(controls.down) && key.has(controls.secondary);
      },
      () => batchMove(Direction.Down, 4)
    );
    input.onKeyPress(
      (key) => {
        const controls = getBrowserControls();
        return key.has(controls.right) && key.has(controls.secondary);
      },
      () => batchMove(Direction.Right, 4)
    );

    if (controlsInterval !== undefined) {
      clearInterval(controlsInterval);
    }

    controlsInterval = setInterval(async () => {
      const keyObjects =
        phaserScene.input.keyboard?.addKeys(getBrowserControls());

      if (!keyObjects) return;
      const { up, down, left, right } = keyObjects as {
        up: Input.Keyboard.Key;
        down: Input.Keyboard.Key;
        left: Input.Keyboard.Key;
        right: Input.Keyboard.Key;
      };

      if (up.isDown) await move(Direction.Up);
      if (down.isDown) await move(Direction.Down);
      if (left.isDown) await move(Direction.Left);
      if (right.isDown) await move(Direction.Right);
    }, ANIMATION_INTERVAL);
  });
}
