import { Entity, setComponent } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { useNavigate, useParams } from "react-router";
import { Hex } from "viem";

import { NetworkLayer, useNetworkLayer } from "@/hooks/use-network-layer";
import { useWorldContract, WorldContract } from "@/hooks/use-world-contract";
import { PlayerStatus } from "@/components/mud/player-status";
import { PhaserWrapper } from "@/components/mud/phaser-wrapper";
import { NotConnected } from "@/components/mud/not-connected";
import { ControlsModal } from "@/components/controls-modal";
import { components } from "@/lib/mud/recs";
import { cn } from "@/lib/utils";
import { useMatchComponents } from "@/hooks/use-match-components";

type Props = {
  worldContract: WorldContract;
  session: Hex;
};

type GameHUDProps = {
  networkLayer: NetworkLayer;
  session: Hex;
};

export const GameHUD = ({ networkLayer, session }: GameHUDProps) => {
  const {
    playerEntity,
    systemCalls: { spawn },
  } = networkLayer;

  const navigate = useNavigate();
  const { players } = useMatchComponents(session as Entity);

  const playerStatuses = players.map((player, i) => (
    <PlayerStatus
      key={i}
      isSelf={player === playerEntity}
      playerEntity={player}
      playerIndex={i}
      onStart={() => spawn()}
      onLeave={() => []}
    />
  ));
  return (
    <div className={cn("w-full flex justify-between", "gap-2")}>
      {playerStatuses}
    </div>
  );
};

export const GameScene = ({ session, worldContract }: Props) => {
  const networkLayer = useNetworkLayer(worldContract);

  return (
    <div className="flex flex-col justify-center items-center h-full gap-2">
      <div
        className={cn(
          "rounded-lg min-w-96 w-max bg-black flex flex-col items-center ring-1 ring-white",
          "gap-3 p-3"
        )}
      >
        <GameHUD session={session} networkLayer={networkLayer} />
        <PhaserWrapper networkLayer={networkLayer} />
      </div>
      <div className="w-full text-right">
        <ControlsModal>
          <p className="transition-all cursor-pointer opacity-60 hover:opacity-100">{`Settings >`}</p>
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

  setComponent(components.LocalSession, singletonEntity, {
    id: session,
  });

  return <GameScene session={session as Hex} worldContract={worldContract} />;
}
