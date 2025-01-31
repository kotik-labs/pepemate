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

import { getComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "./recs";
import { Hex } from "viem";
import { NetworkSetupResult } from "../../hooks/use-network-setup";
import { Direction } from "@/types";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { playerEntity, worldContract, waitForTransaction }: NetworkSetupResult,
  { Position }: ClientComponents
) {
  const spawn = async () => {
    if (!playerEntity) throw new Error("no player");

    const position = getComponentValue(Position, playerEntity);
    if (position && !(position.x == 0 && position.y == 0)) {
      console.warn("already spawned");
      return;
    }

    const tx = await worldContract.write.pepemate__spawn();
    await waitForTransaction(tx);
  };

  const move = async (direction: Direction) => {
    if (!playerEntity) throw new Error("no player");

    const position = getComponentValue(Position, playerEntity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot move without a player position, not yet spawned?");
      return;
    }

    const tx = await worldContract.write.pepemate__move([direction]);
    await waitForTransaction(tx);
  };

  const placeBomb = async () => {
    if (!playerEntity) throw new Error("no player");

    const position = getComponentValue(Position, playerEntity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot move without a player position, not yet spawned?");
      return;
    }

    const tx = await worldContract.write.pepemate__placeBomb();
    await waitForTransaction(tx);
  };

  const triggerBomb = async (session: Hex, x: number, y: number) => {
    const tx = await worldContract.write.pepemate__triggerBomb([session, x, y]);
    await waitForTransaction(tx);
  };

  const joinSession = async (session: Hex, playerIndex: number) => {
    const tx = await worldContract.write.pepemate__joinPublic([
      session,
      playerIndex,
    ]);
    await waitForTransaction(tx);
  };

  const leaveSession = async () => {
    const tx = await worldContract.write.pepemate__leavePublic();
    await waitForTransaction(tx);
  };

  const batchMove = async (direction: Direction, steps: number) => {
    const position = getComponentValue(Position, playerEntity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot move without a player position, not yet spawned?");
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
    triggerBomb,
    batchMove,
    joinSession,
    leaveSession,
  };
}
