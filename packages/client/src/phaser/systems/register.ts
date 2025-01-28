import { PhaserLayer } from "../create-phaser-layer";
import { createCamera } from "./camera-system";
// import { createCursor } from "./cursor-system";
import { createTilemapSystem } from "./tilemap-system";
import { createControlSystem } from "./controls-system";
import { createPlayerSystem } from "./player-system";
import { createBombSystem } from "./bomb-system";

export const registerSystems = (layer: PhaserLayer) => {
  createCamera(layer);
  // createCursor(layer);
  createTilemapSystem(layer);
  createControlSystem(layer);
  createPlayerSystem(layer);
  createBombSystem(layer);
};
