import { PhaserLayer } from "../create-phaser-layer";
import { MAX_HEIGHT, MAX_WIDTH } from "@/constants";

export const createCamera = (layer: PhaserLayer) => {
  const {
    scenes: {
      Main: {
        camera: { phaserCamera },
        // phaserScene: {
        //   sys: { scale },
        // },
      },
    },
  } = layer;

  phaserCamera.setBounds(0, 0, MAX_WIDTH, MAX_HEIGHT, true);
  phaserCamera.centerOn(0, 0);
};
