import { useComponentValue } from "@latticexyz/react";
import { Entity } from "@latticexyz/recs";
import { components } from "@/lib/mud/recs";
import { ZERO_ENTITY } from "@/constants";

const { MatchConfig, MatchTerrain, MatchPlayers } = components;

export const useMatchComponents = (session: Entity) => {
  const players = useComponentValue(MatchPlayers, session);
  const map = useComponentValue(MatchTerrain, session);
  const config = useComponentValue(MatchConfig, session);

  const playersArr = (players?.players || [
    ZERO_ENTITY,
    ZERO_ENTITY,
    ZERO_ENTITY,
    ZERO_ENTITY,
  ]) as Entity[];

  return {
    sessionType: 0,
    terrain: map?.terrain,
    config,
    onlineCount: playersArr.filter((p) => p !== ZERO_ENTITY).length,
    players: playersArr,
  };
};
