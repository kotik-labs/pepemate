import { useMemo } from "react";
import { useNetworkSetup } from "./use-network-setup";
import { createSystemCalls } from "@/lib/mud/system-calls";
import { world, components } from "@/lib/mud/recs";
import { WorldContract } from "@/hooks/use-world-contract";

export const useNetworkLayer = (worldContract: WorldContract) => {
  const setup = useNetworkSetup(worldContract);
  const { playerEntity } = setup;

  const systemCalls = useMemo(() => {
    return createSystemCalls(setup, components);
  }, [setup]);

  return {
    world,
    playerEntity,
    components,
    systemCalls,
  };
};

export type NetworkLayer = ReturnType<typeof useNetworkLayer>;
