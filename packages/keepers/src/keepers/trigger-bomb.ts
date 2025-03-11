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
  components: { BombIndex, EntityMatch },
}: SetupResult) => {
  console.log("Starting bomb keeper..");
  const triggerBomb = async (bomb: Hex) => {
    const tx = await worldContract.write.pepemate__triggerBomb([bomb]);
    return waitForTransaction(tx);
  };

  defineSystem(
    world,
    [Has(BombIndex), Has(EntityMatch)],
    ({ entity, type }) => {
      if (type !== UpdateType.Update && type !== UpdateType.Enter) return;

      const bombIndex = getComponentValue(BombIndex, entity);
      const session = getComponentValue(EntityMatch, entity);
      if (!session || !bombIndex || bombIndex.index == 0) return;

      const tileCoord = {
        x: bombIndex.index % 15,
        y: Math.floor(bombIndex.index / 15),
      };

      console.log("DETONATE", { session: session.session, tileCoord });

      asyncScheduler.schedule(async function task() {
        const bombIndex = getComponentValue(BombIndex, entity);
        const session = getComponentValue(EntityMatch, entity);
        if (!session || !bombIndex || bombIndex.index == 0) return;

        // check fuse, if cant blowup - reschedule
        const { status } = await triggerBomb(entity as Hex);
        if (status === "reverted") this.schedule(null, 0);
      }, 3000);
    }
  );
};
