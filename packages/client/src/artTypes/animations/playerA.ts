import { Animations, Assets } from "../../types";

export const playerAAnimations = [
  {
    key: Animations.PlayerAUp,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerA/move-up/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerADown,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerA/move-down/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerALeft,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerA/move-left/",
    suffix: ".png",
  },
  {
    key: Animations.PlayerARight,
    assetKey: Assets.MainAtlas,
    startFrame: 0,
    endFrame: 3,
    frameRate: 6,
    repeat: 0,
    prefix: "sprites/playerA/move-right/",
    suffix: ".png",
  },
] as const;
