import {
  defineSystem,
  getComponentValue,
  Has,
  UpdateType,
} from "@latticexyz/recs";
import { Hex } from "viem";
import { asyncScheduler } from "rxjs";
import { SetupResult } from "../mud/setup";

export const triggerBombKeeper = async ({
  world,
  worldContract,
  waitForTransaction,
  components: { BombIndex, EntitySession },
}: SetupResult) => {
  console.log("Starting bomb keeper..");
  const triggerBomb = async (session: Hex, x: number, y: number) => {
    const tx = await worldContract.write.pepemate__triggerBomb([session, x, y]);
    return waitForTransaction(tx);
  };

  defineSystem(
    world,
    [Has(BombIndex), Has(EntitySession)],
    ({ entity, type }) => {
      if (type !== UpdateType.Update && type !== UpdateType.Enter) return;

      const bombIndex = getComponentValue(BombIndex, entity);
      const session = getComponentValue(EntitySession, entity);
      if (!session || !bombIndex || bombIndex.index == 0) return;

      const tileCoord = {
        x: bombIndex.index % 15,
        y: Math.floor(bombIndex.index / 15),
      };

      console.log("DETONATE", { session: session.session, tileCoord });

      asyncScheduler.schedule(async function task() {
        const { status } = await triggerBomb(
          session.session as Hex,
          tileCoord.x,
          tileCoord.y
        );
        if (status === "reverted") this.schedule(null, 0);
      }, 3000);
    }
  );
};
