import { playerAAnimations } from "./playerA";
import { playerBAnimations } from "./playerB";
import { playerCAnimations } from "./playerC";
import { playerDAnimations } from "./playerD";
import { explosionAnimations } from "./explosion";
import { wallAnimations } from "./wall";

export const AllAnimations = [
  ...playerAAnimations,
  ...playerBAnimations,
  ...playerCAnimations,
  ...playerDAnimations,
  ...explosionAnimations,
  ...wallAnimations,
];
