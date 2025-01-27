import { WorldContract } from "@/hooks/use-world-contract";
import { useSync } from "@latticexyz/store-sync/react";
import { useCallback, useMemo } from "react";
import { ZERO_ENTITY } from "@/constants";
import { encodeAbiParameters, Hex } from "viem";
import { Entity } from "@latticexyz/recs";
import { useAccount } from "wagmi";

export const useNetworkSetup = (worldContract: WorldContract) => {
  const { address: userAddress } = useAccount();
  const { data: sync } = useSync();

  const playerEntity = useMemo(() => {
    if (!userAddress) return ZERO_ENTITY;

    return encodeAbiParameters([{ type: "address" }], [userAddress]) as Entity;
  }, [userAddress]);

  const waitForTransaction = useCallback(
    (txHash: Hex) => {
      if (!sync) return Promise.resolve(null);

      return sync.waitForTransaction(txHash);
    },
    [sync]
  );

  return { playerEntity, worldContract, waitForTransaction };
};

export type NetworkSetupResult = ReturnType<typeof useNetworkSetup>;
