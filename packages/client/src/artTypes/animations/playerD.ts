import { Animations, Assets } from "../../types";

export const playerDAnimations = [
  {
    key: Animations.PlayerDUp,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerD/move-up/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerDDown,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerD/move-down/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerDLeft,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerD/move-left/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerDRight,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerD/move-right/",
    suffix: ".png",
  },
] as const;
