import { playerAnimations } from "./player";
import { playerAAnimations } from "./playerA";
import { playerBAnimations } from "./playerB";
import { explosionAnimations } from "./explosion";
import { wallAnimations } from "./wall";

export const AllAnimations = [
  ...playerAnimations,
  ...playerAAnimations,
  ...playerBAnimations,
  ...explosionAnimations,
  ...wallAnimations,
];
