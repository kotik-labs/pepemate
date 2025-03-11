/*
 * Creates components for use by the client.
 *
 * By default it returns the components from setupNetwork.ts, those which are
 * automatically inferred from the mud.config.ts table definitions.
 *
 * However, you can add or override components here as needed. This
 * lets you add user defined components, which may or may not have
 * an onchain component.
 */

import { Entity, getComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "./recs";
import { Hex } from "viem";
import { NetworkSetupResult } from "../../hooks/use-network-setup";
import { Direction } from "@/types";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { playerEntity, worldContract, waitForTransaction }: NetworkSetupResult,
  { Position, MatchLookup }: ClientComponents
) {
  const spawn = async () => {
    if (!playerEntity) throw new Error("no player");

    const match = getComponentValue(MatchLookup, playerEntity);
    if (!match) {
      console.warn("no match lookup data");
      return;
    }
    const position = getComponentValue(Position, match.player as Entity);
    if (position && position.x !== 0 && position.y !== 0) {
      console.warn("Already spawned");
      return;
    }

    const tx = await worldContract.write.pepemate__spawn();
    console.log(await waitForTransaction(tx));
  };

  const move = async (direction: Direction) => {
    if (!playerEntity) throw new Error("no player");

    const match = getComponentValue(MatchLookup, playerEntity);
    if (!match) {
      console.warn("no match lookup data");
      return;
    }
    const position = getComponentValue(Position, match.player as Entity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot move without a player position, not yet spawned?");
      return;
    }

    const tx = await worldContract.write.pepemate__move([direction]);
    await waitForTransaction(tx);
  };

  const placeBomb = async () => {
    if (!playerEntity) throw new Error("no player");

    const match = getComponentValue(MatchLookup, playerEntity);
    if (!match) {
      console.warn("no match lookup data");
      return;
    }
    const position = getComponentValue(Position, match.player as Entity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot place bomb, not yet spawned?");
      return;
    }

    const tx = await worldContract.write.pepemate__placeBomb();
    await waitForTransaction(tx);
  };

  const joinQueue = async (map: Hex) => {
    const tx = await worldContract.write.pepemate__searchMatch([map]);
    await waitForTransaction(tx);
  };

  const leaveQueue = async () => {
    const tx = await worldContract.write.pepemate__leaveSearch();
    await waitForTransaction(tx);
  };

  const batchMove = async (direction: Direction, steps: number) => {
    if (!playerEntity) throw new Error("no player");

    const match = getComponentValue(MatchLookup, playerEntity);
    if (!match) {
      console.warn("no match lookup data");
      return;
    }
    const position = getComponentValue(Position, match.player as Entity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot place bomb, not yet spawned?");
      return;
    }

    const tx = await worldContract.write.pepemate__move([
      direction,
      BigInt(steps),
    ]);
    await waitForTransaction(tx);
  };

  return {
    spawn,
    move,
    placeBomb,
    batchMove,
    joinQueue,
    leaveQueue,
  };
}
