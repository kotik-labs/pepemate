import { SetupResult } from "../mud/setup";
import { triggerBombKeeper } from "./trigger-bomb";
import { matchmakingKeeper } from "./matchmaking";

export const setupKeepers = async (setupResult: SetupResult) => {
  return Promise.all([
    triggerBombKeeper(setupResult),
    matchmakingKeeper(setupResult),
  ]);
};
