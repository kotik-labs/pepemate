import { useComponentValue } from "@latticexyz/react";
import { Entity } from "@latticexyz/recs";
import { components } from "@/lib/mud/recs";

const { Player, Tick, FireCount, BombCount, BombUsed } = components;

export const usePlayerComponents = (player: Entity) => {
  const isPlayer = useComponentValue(Player, player);
  const fireCount = useComponentValue(FireCount, player);
  const bombUsed = useComponentValue(BombUsed, player);
  const bombCount = useComponentValue(BombCount, player);
  const tick = useComponentValue(Tick, player);

  return {
    isPlayer: isPlayer?.isPlayer || false,
    fireCount: fireCount?.value || 1,
    bombCount: bombCount?.value || 1,
    bombUsed: bombUsed?.value || 0,
    tick: { count: tick?.count || 0 },
  };
};
