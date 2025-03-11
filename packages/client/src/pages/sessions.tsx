import { Card, CardContent } from "@/components/ui/card";
import { shorten } from "@/lib/utils";
import { Link } from "react-router";

import { Hex, toBytes } from "viem";
import { useEntityQuery } from "@latticexyz/react";
import { Entity, HasValue } from "@latticexyz/recs";
import { useWorldContract } from "@/hooks/use-world-contract";
import { NotConnected } from "@/components/mud/not-connected";
import { ControlsModal } from "@/components/controls-modal";
import { AddressStatus } from "@/components/mud/address-status";
import { TilemapPreview } from "@/components/mud/tilemap-preview";
import { useMatchComponents } from "@/hooks/use-match-components";
import { components } from "@/lib/mud/recs";
import { useAddressComponents } from "@/hooks/use-address-components";
import { useNetworkLayer } from "@/hooks/use-network-layer";

const { Session } = components;

export const SessionList = ({ worldContract }: any) => {
  const {
    playerEntity,
    systemCalls: { joinQueue },
  } = useNetworkLayer(worldContract);
  const a = useAddressComponents(playerEntity);
  console.log(a);

  const sessions = useEntityQuery([HasValue(Session, { sessionType: 1 })]);

  return (
    <div
      className="flex flex-col justify-start gap-4 border-2"
      onClick={() =>
        joinQueue(
          "0x3ecc5ccdb14427749d5eaf6330ed361cd589b2f1ea2ccbff555f187b35c361cd"
        )
      }
    >
      {sessions.map((session, i) => (
        <SessionItem key={i} session={session as Hex} />
      ))}
    </div>
  );
};

export const SessionItem = ({ session }: { session: Hex }) => {
  const { sessionType, onlineCount, terrain } = useMatchComponents(
    session as Entity
  );

  if (sessionType !== 1) return;

  return (
    <Link to={`/${session}`}>
      <div className="ring-2 rounded-md ring-slate-700 hover:ring-slate-50 flex gap-2 items-center">
        <TilemapPreview
          width={45}
          height={45}
          tileSize={4}
          terrain={toBytes(terrain || "0x0")}
        />

        <div className="flex flex-col gap-1 py-1">
          <span className="text-sm">{shorten(session, 6)}</span>
          <span className="text-xs">{onlineCount}/4 players</span>
        </div>
      </div>
    </Link>
  );
};

export function Sessions() {
  const worldContract = useWorldContract();
  if (!worldContract) return <NotConnected />;

  return (
    <div className="flex flex-col items-center gap-2">
      <AddressStatus worldContract={worldContract} />
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
      <div className="w-full text-right">
        <ControlsModal>
          <p className="transition-all cursor-pointer opacity-60 hover:opacity-100">{`Settings >`}</p>
        </ControlsModal>
      </div>
    </div>
  );
}
