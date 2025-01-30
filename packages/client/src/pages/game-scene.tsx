import { setComponent } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { useParams } from "react-router";
import { range } from "lodash";
import { Hex } from "viem";

import { useNetworkLayer } from "@/hooks/use-network-layer";
import { useWorldContract, WorldContract } from "@/hooks/use-world-contract";
import { PlayerStatus } from "@/components/mud/player-status";
import { PhaserWrapper } from "@/components/mud/phaser-wrapper";
import { cn } from "@/lib/utils";
import { NotConnected } from "@/components/mud/not-connected";
import { ControlsModal } from "@/components/controls-modal";

type Props = {
  worldContract: WorldContract;
  session: Hex;
};

export const GameScene = ({ session, worldContract }: Props) => {
  const networkLayer = useNetworkLayer(worldContract);
  setComponent(networkLayer.components.LocalSession, singletonEntity, {
    id: session,
  });

  const totalPlayers = 4;
  const playerStatuses = range(0, totalPlayers).map((i) => (
    <PlayerStatus
      key={i}
      playerIndex={i}
      session={session}
      networkLayer={networkLayer}
    />
  ));

  return (
    <div className="flex flex-col justify-center items-center h-full gap-2">
      <div
        className={cn(
          "rounded-lg min-w-96 w-max bg-black flex flex-col items-center ring-1 ring-white",
          "gap-3 p-3"
        )}
      >
        <div className={cn("w-full flex justify-between", "gap-2")}>
          {playerStatuses}
        </div>
        <PhaserWrapper networkLayer={networkLayer} />
      </div>
      <div className="w-full text-right">
        <ControlsModal>
          <p className="transition-all cursor-pointer hover:text-slate-50">{`Settings >`}</p>
        </ControlsModal>
      </div>
    </div>
  );
};

export function Game() {
  const { session } = useParams();
  const worldContract = useWorldContract();

  if (!worldContract) return <NotConnected />;
  if (!session) return <NotConnected />;

  return <GameScene session={session as Hex} worldContract={worldContract} />;
}
