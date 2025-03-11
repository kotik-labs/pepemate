import { Hex } from "viem";
import { SetupResult } from "../mud/setup";
import { asyncScheduler, from, of, zip } from "rxjs";
import { groupBy, mergeMap, toArray, map, filter } from "rxjs/operators";
import { getComponentEntities, getComponentValue } from "@latticexyz/recs";
import { toEthAddress } from "@latticexyz/utils";

type PlayerArray = [Hex, Hex, Hex, Hex];

export const matchmakingKeeper = async ({
  worldContract,
  waitForTransaction,
  components: { InQueue },
}: SetupResult) => {
  console.log("Starting matchmaking..");

  const settleMatch = async (map: Hex, players: PlayerArray) => {
    const tx = await worldContract.write.pepemate__settleMatch([map, players]);
    return waitForTransaction(tx);
  };

  asyncScheduler.schedule(async function task() {
    from(getComponentEntities(InQueue))
      .pipe(
        map((entity) => {
          return { entity, queue: getComponentValue(InQueue, entity) };
        }),

        groupBy(({ queue }) => queue?.map || "0x0"),

        mergeMap((group) =>
          zip(
            of(group.key),
            group.pipe(
              map(({ entity }) => toEthAddress(entity)),
              toArray()
            )
          )
        ),

        filter(([map, players]) => {
          return map !== "0x0" && players.length === 4;
        })
      )
      .subscribe(async ([map, players]) => {
        const resp = await settleMatch(map as Hex, players as PlayerArray);
        console.log("new match", resp);
      });

    this.schedule(null, 200);
  }, 0);
};
