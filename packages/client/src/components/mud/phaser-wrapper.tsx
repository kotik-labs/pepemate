import React from "react";
import { NetworkLayer } from "@/hooks/use-network-layer";
import { usePhaserLayer } from "@/hooks/use-phaser-layer";

type Props = {
  networkLayer: NetworkLayer | null;
};

export const PhaserWrapper = ({ networkLayer }: Props) => {
  const { ref: phaserRef, phaserLayer } = usePhaserLayer({
    networkLayer,
  });

  // TODO: remove duplicated phaser canvases

  return <div ref={phaserRef} />;
};
