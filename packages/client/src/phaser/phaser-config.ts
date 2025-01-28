import Phaser from "phaser";
import {
  defineSceneConfig,
  AssetType,
  defineScaleConfig,
  defineMapConfig,
  defineCameraConfig,
} from "@latticexyz/phaserx";
import worldTileset from "@/../public/assets/tilesets/world.png";
import { TileAnimations, Tileset } from "@/artTypes/world";
import {
  ANIMATION_INTERVAL,
  TILE_HEIGHT,
  TILE_WIDTH,
  DEFAULT_SCALE,
  MAX_WIDTH,
  MAX_HEIGHT,
} from "@/constants";
import { Sprites, Assets, Maps, Scenes } from "@/types";
import { AllAnimations } from "@/artTypes/animations";

const mainMap = defineMapConfig({
  // chunkSize: TILE_WIDTH * TILE_HEIGHT, // tile size * tile amount
  chunkSize: TILE_WIDTH * MAX_WIDTH * MAX_HEIGHT,
  tileWidth: TILE_WIDTH,
  tileHeight: TILE_HEIGHT,
  backgroundTile: [Tileset.Void],
  animationInterval: ANIMATION_INTERVAL,
  tileAnimations: TileAnimations,
  layers: {
    layers: {
      Background: { tilesets: ["Default"] },
      Foreground: { tilesets: ["Default"] },
    },
    defaultLayer: "Background",
  },
});

export const phaserConfig = {
  sceneConfig: {
    [Scenes.Main]: defineSceneConfig({
      assets: {
        [Assets.Tileset]: {
          type: AssetType.Image,
          key: Assets.Tileset,
          path: worldTileset,
        },
        [Assets.MainAtlas]: {
          type: AssetType.MultiAtlas,
          key: Assets.MainAtlas,
          // Add a timestamp to the end of the path to prevent caching
          path: `/assets/atlases/atlas.json?timestamp=${Date.now()}`,
          options: {
            imagePath: "/assets/atlases/",
          },
        },
      },
      maps: {
        [Maps.Main]: mainMap,
      },
      sprites: {
        [Sprites.PlayerA]: {
          assetKey: Assets.MainAtlas,
          frame: "sprites/playerA/move-down/1.png",
        },
        [Sprites.PlayerB]: {
          assetKey: Assets.MainAtlas,
          frame: "sprites/playerB/move-down/1.png",
        },
        [Sprites.PlayerC]: {
          assetKey: Assets.MainAtlas,
          frame: "sprites/playerC/move-down/1.png",
        },
        [Sprites.PlayerD]: {
          assetKey: Assets.MainAtlas,
          frame: "sprites/playerD/move-down/1.png",
        },
      },
      animations: AllAnimations,
      tilesets: {
        Default: {
          assetKey: Assets.Tileset,
          tileWidth: TILE_WIDTH,
          tileHeight: TILE_HEIGHT,
        },
      },
    }),
  },
  scale: defineScaleConfig({
    parent: "phaser-game",
    zoom: DEFAULT_SCALE,
    mode: Phaser.Scale.NONE,
    autoRound: true
  }),
  cameraConfig: defineCameraConfig({
    pinchSpeed: 1,
    wheelSpeed: 1,
    maxZoom: 1,
    minZoom: 1,
  }),
  cullingChunkSize: 1,
};
