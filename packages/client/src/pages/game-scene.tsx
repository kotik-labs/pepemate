import { setComponent } from "@latticexyz/recs";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { useParams } from "react-router";
import { range } from "lodash";
import { Hex } from "viem";

import { useNetworkLayer } from "@/hooks/use-network-layer";
import { useWorldContract } from "@/hooks/use-world-contract";
import { PlayerStatus } from "@/components/mud/player-status";
import { PhaserWrapper } from "@/components/mud/phaser-wrapper";

export const GameScene = ({ session, worldContract }: any) => {
  const networkLayer = useNetworkLayer(worldContract);
  setComponent(networkLayer.components.LocalSession, singletonEntity, {
    id: session,
  });

  const totalPlayers = 4;
  const playerStatuses = range(0, totalPlayers).map((i) => (
    <PlayerStatus
      key={i}
      playerIndex={i}
      session={session as Hex}
      networkLayer={networkLayer}
    />
  ));

  return (
    <div className="flex flex-col justify-center items-center h-full">
      <div className={"rounded-lg p-4 w-max bg-black"}>
        <div className="flex flex-row pb-4 gap-4 justify-between">
          {playerStatuses}
        </div>
        <PhaserWrapper networkLayer={networkLayer} />
      </div>
    </div>
  );
};

export function Game() {
  const { session } = useParams();
  const worldContract = useWorldContract();

  if (!session) return;
  if (!worldContract) return;

  return <GameScene session={session} worldContract={worldContract} />;
}
