import { useEntityQuery } from "@latticexyz/react";
import { getComponentValue, Has, HasValue } from "@latticexyz/recs";

import { Heart, Flame, Bomb, LogOut } from "lucide-react";
import { decodeAbiParameters, Hex, parseAbiParameters } from "viem";
import { NetworkLayer } from "@/hooks/use-network-layer";
import { Avatar, AvatarImage } from "@/components/ui/avatar";
import { Progress } from "@/components/ui/progress";
import { Card } from "@/components/ui/card";

import playerA from "../../../public/playerA.png";
import playerB from "../../../public/playerB.png";
import { MAX_TICKS_PER_BLOCK } from "@/constants";
import { cn, shorten } from "@/lib/utils";

export type PlayerStatusProps = {
  networkLayer: NetworkLayer;
  session: Hex;
  playerIndex: number;
};

export type IconStatusProps = {
  icon: typeof Heart;
  iconClassName: string;
  count: number;
  max?: number;
};

export const IconStatus = ({
  max,
  count,
  icon: Icon,
  iconClassName,
}: IconStatusProps) => {
  max = max ?? count;

  return (
    <div className="relative flex -space-x-2">
      {Array.from({ length: max }).map((_, i) => (
        <Icon
          key={i}
          className={cn(
            "h-3 w-3 fill-black drop-shadow-[0_2px_2px_rgba(0,0,0,0.5)]",
            iconClassName,
            i + 1 > count ? "text-gray-500" : null
          )}
          style={{
            transform: `translateX(-${(i * 1) / 6}px)`,
            zIndex: 10 - i,
          }}
        />
      ))}
    </div>
  );
};

const playerImages = [playerA, playerB, playerA, playerB];

export const PlayerStatus = ({
  networkLayer,
  session,
  playerIndex,
}: PlayerStatusProps) => {
  const {
    playerEntity,
    components: {
      PlayerIndex,
      SessionOf,
      TickCount,
      FireCount,
      BombCount,
      BombUsed,
    },
    systemCalls: { joinSession, leaveSession },
  } = networkLayer;
  const playerImage = playerImages[playerIndex];

  const [pEntity] = useEntityQuery([
    HasValue(PlayerIndex, { value: playerIndex }),
    HasValue(SessionOf, { value: session }),
    Has(TickCount),
  ]);

  if (!pEntity) {
    return (
      <Card
        onClick={() => joinSession(session, playerIndex)}
        className={cn(
          "opacity-50 hover:opacity-100",
          "w-1/4 pr-2 border-0 bg-black rounded-none relative overflow-hidden"
        )}
      >
        <div className="flex items-center justify-center gap-2">
          <Avatar className="w-8 h-8 rounded border-2 border-yellow-500">
            <AvatarImage src={playerImage} className="object-cover" />
          </Avatar>

          <div className="flex-1 flex flex-col ">
            <div className="flex-1 space-y-4 text-center text-yellow-500">
              <span className="text-xl font-bold">START</span>
            </div>
          </div>
        </div>
        <Progress
          value={0}
          className="h-1 mt-2 w-full pixelated border bg-transparent"
        />
      </Card>
    );
  }

  const [address] = decodeAbiParameters(parseAbiParameters("address"), pEntity);

  const isSelf = pEntity === playerEntity;
  const { value: fireCount } = getComponentValue(FireCount, pEntity) || {
    value: 0,
  };
  const { value: bombCount } = getComponentValue(BombUsed, pEntity) || {
    value: 0,
  };
  const { value: bombMaxCount } = getComponentValue(BombCount, pEntity) || {
    value: 0,
  };
  const { value: tickCount } = getComponentValue(TickCount, pEntity) || {
    value: 0,
  };

  const stamina = (tickCount / MAX_TICKS_PER_BLOCK) * 100;

  return (
    <Card className="w-1/4 pr-2 border-0 bg-black rounded-none relative overflow-hidden">
      <div className="flex items-start gap-2">
        <Avatar className="w-8 h-8 rounded border-2 border-yellow-500">
          <AvatarImage src={playerImage} className="object-cover" />
        </Avatar>

        <div className="flex-1 flex flex-col gap-1">
          <div className="flex flex-row justify-between items-center">
            <span className="text-xs font-bold text-white">
              {shorten(address)}
            </span>
            {isSelf ? (
              <LogOut
                onClick={() => leaveSession()}
                className="h-4 w-4 text-red-500 hover:text-red-800 cursor-pointer"
              />
            ) : null}
          </div>

          <div className="flex items-center px-0.5">
            {/* <IconStatus
              icon={Heart}
              iconClassName={"text-red-500"}
              count={2}
              max={3}
            /> */}
            <IconStatus
              icon={Flame}
              iconClassName={"text-orange-500"}
              count={fireCount || 2}
            />
            <IconStatus
              icon={Bomb}
              iconClassName={"text-purple-500"}
              count={bombMaxCount - bombCount || 0}
              max={bombMaxCount || 1}
            />
          </div>
        </div>
      </div>
      <Progress
        value={stamina}
        className="h-1 mt-2 w-full pixelated border bg-transparent"
        indicatorClassName={cn(
          "transition-all duration-300",
          stamina > 66 && "bg-green-400",
          stamina > 33 && stamina <= 66 && "bg-yellow-400",
          stamina <= 33 && "bg-red-400"
        )}
      />
    </Card>
  );
};
