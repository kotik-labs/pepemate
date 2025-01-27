import { Animations, Assets } from "../../types";

export const playerAnimations = [
  {
    key: Animations.PlayerDeath,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/player/death/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerUp,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 24,
    repeat: 0,
    prefix: "sprites/player/move-up/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerDown,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 24,
    repeat: 0,
    prefix: "sprites/player/move-down/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerLeft,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 24,
    repeat: 0,
    prefix: "sprites/player/move-left/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerRight,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 24,
    repeat: 0,
    prefix: "sprites/player/move-right/",
    suffix: ".png",
  },
] as const;
