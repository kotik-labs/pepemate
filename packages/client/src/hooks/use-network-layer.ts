import { useMemo } from "react";
import { useNetworkSetup } from "./use-network-setup";
import { createClientComponents } from "@/lib/mud/client-components";
import { createSystemCalls } from "@/lib/mud/create-system-calls";
import { world, components as systemComponents } from "@/lib/mud/recs";
import { WorldContract } from "@/hooks/use-world-contract";

const components = createClientComponents({
  components: systemComponents,
  world,
});

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
