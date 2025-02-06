
import { Hex, Account } from "viem";
import { syncToRecs } from "@latticexyz/store-sync/recs";
import { world } from "./world";
import mudConfig from "contracts/mud.config";
import { getWorldContract, getChainId, startBlock } from "./common";
import { getClient } from "@wagmi/core";
import { wagmiConfig } from "./wagmi-config";

export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup(burnerAccount: Account) {
  const client = getClient(wagmiConfig, {
    chainId: getChainId(),
  });

  const worldContract = getWorldContract(client, burnerAccount);
  const { components, latestBlock$, storedBlockLogs$, waitForTransaction } =
    await syncToRecs({
      world,
      config: mudConfig,
      address: worldContract.address as Hex,
      publicClient: client,
      startBlock: startBlock,
    });

  
  return {
    world,
    components,
    waitForTransaction,
    worldContract,
    latestBlock$,
    storedBlockLogs$
  };
}
