import { Animations, Assets } from "../../types";

export const playerCAnimations = [
  {
    key: Animations.PlayerCUp,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerC/move-up/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerCDown,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerC/move-down/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerCLeft,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerC/move-left/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerCRight,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerC/move-right/",
    suffix: ".png",
  },
] as const;
