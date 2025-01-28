import { Card, CardContent } from "@/components/ui/card";
import { shorten } from "@/lib/utils";
import { Link } from "react-router";

import { Hex } from "viem";
import { useEntityQuery } from "@latticexyz/react";
import { Has, HasValue } from "@latticexyz/recs";
import { useNetworkLayer } from "@/hooks/use-network-layer";
import { useWorldContract, WorldContract } from "@/hooks/use-world-contract";
import { NotConnected } from "@/components/mud/not-connected";

export type SessionListProps = {
  worldContract: WorldContract;
};

export const SessionList = ({ worldContract }: SessionListProps) => {
  const {
    components: { Session },
  } = useNetworkLayer(worldContract);

  const sessions = useEntityQuery([Has(Session)]);

  return (
    <div className="flex flex-col justify-start gap-4">
      {sessions.map((session, i) => (
        <SessionItem
          key={i}
          worldContract={worldContract}
          session={session as Hex}
        />
      ))}
    </div>
  );
};

export type SessionItemProps = {
  worldContract: WorldContract;
  session: Hex;
};

export const SessionItem = ({ worldContract, session }: SessionItemProps) => {
  const {
    components: { SessionOf, PlayerIndex },
  } = useNetworkLayer(worldContract);

  const players = useEntityQuery([
    HasValue(SessionOf, { value: session }),
    Has(PlayerIndex),
  ]);
  const playerCount = players.length;

  return (
    <Link
      className="ring-2 px-2 rounded-md ring-slate-700 hover:ring-slate-50 flex justify-between"
      to={`/${session}`}
    >
      <span>{shorten(session)}</span>
      <span>{playerCount}/4</span>
    </Link>
  );
};

export function Sessions() {
  const worldContract = useWorldContract();

  if (!worldContract) return <NotConnected />;

  return (
    <Card className="w-96 bg-black text-white">
      <CardContent>
        <div>
          <div className="my-4">
            <p>Sessions</p>
          </div>
          <SessionList worldContract={worldContract} />
        </div>
      </CardContent>
    </Card>
  );
}
