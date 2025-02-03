import { Entity } from "@latticexyz/recs";
import { Heart, Flame, Bomb, LogOut } from "lucide-react";
import { decodeAbiParameters, Hex, parseAbiParameters } from "viem";
import { Avatar, AvatarImage } from "@/components/ui/avatar";
import { Progress } from "@/components/ui/progress";
import { Card } from "@/components/ui/card";
import { MAX_TICKS_PER_BLOCK, ZERO_ENTITY } from "@/constants";
import { cn, shorten } from "@/lib/utils";
import { usePlayerComponents } from "@/hooks/use-player-components";

import playerA from "@/static/playerA.png";
import playerB from "@/static/playerB.png";
import playerC from "@/static/playerC.png";
import playerD from "@/static/playerD.png";

export type PlayerStatusProps = {
  playerEntity: Entity;
  playerIndex: number;
  isSelf: boolean;
  onStart: VoidFunction;
  onLeave: VoidFunction;
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

const playerImages = [playerA, playerB, playerC, playerD];

export const PlayerStatus = ({
  isSelf,
  playerEntity,
  playerIndex,
  onStart,
  onLeave,
}: PlayerStatusProps) => {
  const playerImage = playerImages[playerIndex];

  const {
    isPlayer: isAlive,
    fireCount,
    bombCount,
    bombUsed,
    tick: { count: tickCount },
  } = usePlayerComponents(playerEntity);

  const stamina = (tickCount / MAX_TICKS_PER_BLOCK) * 100;
  const [address] = decodeAbiParameters(
    parseAbiParameters("address"),
    playerEntity as Hex
  );

  if (playerEntity === ZERO_ENTITY) {
    return (
      <Card
        onClick={() => onStart()}
        className={cn(
          "opacity-50  hover:opacity-100",
          "w-36 border-0 bg-black rounded-none relative overflow-hidden cursor-pointer"
        )}
      >
        <div className="flex items-center justify-center gap-2">
          <Avatar className="w-8 h-8 rounded border-2 border-yellow-500">
            <AvatarImage src={playerImage} className="object-cover pixelated" />
          </Avatar>

          <div className="flex-1 flex flex-col ">
            <div className="flex-1 space-y-4 text-center text-yellow-500">
              <span className="xs:text-md text-xs font-bold">START</span>
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

  if (!isAlive) {
    return (
      <Card
        className={cn(
          "opacity-50",
          "w-36 border-0 bg-black rounded-none relative overflow-hidden cursor-pointer"
        )}
      >
        <div className="flex items-center justify-center gap-2">
          <Avatar className="w-8 h-8 rounded border-2 border-yellow-500">
            <AvatarImage src={playerImage} className="object-cover pixelated" />
          </Avatar>

          <div className="flex-1 flex flex-col ">
            <div className="flex-1 space-y-4 text-center text-red-500">
              <span className="xs:text-md text-xs font-bold">DEAD</span>
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

  return (
    <Card className=" w-36 border-0 bg-black rounded-none relative overflow-hidden">
      <div className="flex items-start gap-2">
        <Avatar className="w-8 h-8 rounded border-2 border-yellow-500">
          <AvatarImage src={playerImage} className="object-cover pixelated" />
        </Avatar>

        <div className="flex-1 flex flex-col gap-1 max-w-full">
          <div className="flex items-center gap-1">
            <span className="text-[0.5rem] max-w-24 truncate text-white">
              {shorten(address)}
            </span>
            <LogOut
              onClick={() => (isSelf ? onLeave() : null)}
              className={cn(
                "h-3 w-3 text-red-500 hover:text-red-800 cursor-pointer",
                !isSelf
                  ? "text-transparent hover:text-transparent cursor-default"
                  : null
              )}
            />
          </div>

          <div className="flex items-center">
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
              count={bombCount - bombUsed || 0}
              max={bombCount || 1}
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
