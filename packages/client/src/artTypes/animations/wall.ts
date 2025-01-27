import { Animations, Assets } from "../../types";

export const wallAnimations = [
  {
    key: Animations.WallDestroy,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 8,
    frameRate: 12,
    repeat: 0,
    prefix: "sprites/wall/destroy/",
    suffix: ".png",
  },
] as const;
