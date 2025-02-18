import { Animations, Assets } from "../../types";

export const playerBAnimations = [
  {
    key: Animations.PlayerBUp,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerB/move-up/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerBDown,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerB/move-down/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerBLeft,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerB/move-left/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerBRight,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerB/move-right/",
    suffix: ".png",
  },
] as const;
