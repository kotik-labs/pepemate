import { useComponentValue } from "@latticexyz/react";
import { Entity } from "@latticexyz/recs";
import { components } from "@/lib/mud/recs";
import { ZERO_ENTITY } from "@/constants";

const { Session, SessionMap, SessionPlayers } = components;

export const useSessionComponents = (session: Entity) => {
  const players = useComponentValue(SessionPlayers, session);
  const map = useComponentValue(SessionMap, session);
  const sessionType = useComponentValue(Session, session);

  const playersArr = (players?.players || [
    ZERO_ENTITY,
    ZERO_ENTITY,
    ZERO_ENTITY,
    ZERO_ENTITY,
  ]) as Entity[];

  return {
    sessionType: sessionType?.sessionType,
    map: { terrain: map?.terrain, mapId: map?.mapId },
    onlineCount: playersArr.filter((p) => p !== ZERO_ENTITY).length,
    players: playersArr,
  };
};
