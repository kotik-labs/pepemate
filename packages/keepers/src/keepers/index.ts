import { SetupResult } from "../mud/setup";
import { triggerBombKeeper } from "./trigger-bomb";


export const setupKeepers = async (setupResult: SetupResult) => {
  return Promise.all([
    triggerBombKeeper(setupResult)
  ]);
}