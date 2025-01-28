import { useLayoutEffect } from "react";
import { createPhaserLayer } from "@/phaser/create-phaser-layer";
import { NetworkLayer } from "@/hooks/use-network-layer";
import { phaserConfig } from "@/phaser/phaser-config";
import {
  DEFAULT_SCALE,
  MAX_HEIGHT,
  MAX_WIDTH,
  TILE_HEIGHT,
  TILE_WIDTH,
} from "@/constants";
import { cn } from "@/lib/utils";

type Props = {
  networkLayer: NetworkLayer;
};
const gameWidth = TILE_WIDTH * MAX_WIDTH * DEFAULT_SCALE;
const gameHeight = TILE_HEIGHT * MAX_HEIGHT * DEFAULT_SCALE;

export const PhaserWrapper = ({ networkLayer }: Props) => {
  useLayoutEffect(() => {
    const phaserLayerPromise = createPhaserLayer(networkLayer, phaserConfig);
    return () => {
      phaserLayerPromise?.then((phaserLayer) =>
        phaserLayer.network.world.dispose()
      );
    };
  }, [networkLayer]);

  return (
    <div
      id="phaser-game"
      style={{ width: gameWidth, height: gameHeight }}
      className={cn("overflow-hidden pointer-events-auto")}
    />
  );
};
