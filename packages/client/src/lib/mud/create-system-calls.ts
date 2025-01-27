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
import { resourceToHex } from "@latticexyz/common";
import { ClientComponents } from "./client-components";
import { Hex, parseAbi, encodeFunctionData } from "viem";
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
    const tx = await worldContract.write.pepemate__joinSession([
      session,
      playerIndex,
    ]);
    console.log({ receipt: await waitForTransaction(tx) });
  };

  const leaveSession = async () => {
    const tx = await worldContract.write.pepemate__leaveSession();
    await waitForTransaction(tx);
  };

  const batchMove = async (directions: Direction[]) => {
    const position = getComponentValue(Position, playerEntity);
    if (!position || (position.x === 0 && position.y === 0)) {
      console.warn("cannot move without a player position, not yet spawned?");
      return;
    }

    const PlayerSystemId = resourceToHex({
      type: "system",
      namespace: "pepemate",
      name: "PlayerSystem",
    });

    const tx = await worldContract.write.batchCall([
      directions.map((direction) => ({
        systemId: PlayerSystemId,
        callData: encodeFunctionData({
          abi: parseAbi([
            "function move(uint8 direction) public returns (uint32 x, uint32 y)",
          ]),
          args: [direction],
        }),
      })),
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
