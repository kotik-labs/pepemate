import Blockies from "react-blockies";
import { decodeAbiParameters, Hex, parseAbiParameters } from "viem";
import { WorldContract } from "@/hooks/use-world-contract";
import { useNetworkLayer } from "@/hooks/use-network-layer";
import { Avatar } from "@/components/ui/avatar";
import { Card } from "@/components/ui/card";

import { cn, shorten } from "@/lib/utils";
import { LogOut } from "lucide-react";

export type PlayerStatusProps = {
  worldContract: WorldContract;
};

export const AddressStatus = ({ worldContract }: PlayerStatusProps) => {
  const { playerEntity } = useNetworkLayer(worldContract);

  const [address] = decodeAbiParameters(
    parseAbiParameters("address"),
    playerEntity as Hex
  );

  return (
    <Card
      className={cn(
        "w-96 px-6 py-4 bg-black relative overflow-hidden cursor-pointer"
      )}
    >
      <div className="flex gap-4">
        <Avatar className="rounded border-2 border-yellow-500">
          {/* <AvatarImage src={playerImage} className="" /> */}
          <Blockies
            seed={address}
            size={8}
            scale={4.3}
            className="m-auto object-contain"
          />
        </Avatar>
        <div className="w-full flex flex-col items-start justify-between">
          <div className="w-full flex items-center justify-between">
            <span className="text-center text-yellow-500 text-sm">
              {shorten(address, 7)}
            </span>
            <LogOut
              onClick={() => null}
              className={cn("w-4 h-4 text-red-500 hover:text-red-800 cursor-pointer")}
            />
          </div>

          <div className="w-full flex gap-4 items-start">
            <span className="text-xs text-white">ETH:XX</span>
            <span className="text-xs text-white">
              {`Rank:`}
              <span className="text-green-500 text-xs">XX</span>
            </span>
          </div>
        </div>
      </div>
    </Card>
  );
};
