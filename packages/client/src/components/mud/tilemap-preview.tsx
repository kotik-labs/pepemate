import { MAX_HEIGHT, MAX_WIDTH, TILESET_COLORS } from "@/constants";
import { positionToIndex } from "@/lib/game/grid-map";
import { useEffect, useRef } from "react";
import { ByteArray } from "viem";

export type Props = {
  terrain: ByteArray;
  width: number;
  height: number;
  tileSize: number;
};

export const TilemapPreview = ({ terrain, width, height }: Props) => {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const context = canvas.getContext("2d");
    if (!context) return;

    context.canvas.width = width;
    context.canvas.height = height;

    const tileWidth = Math.floor(width / MAX_WIDTH);
    const tileHeight = Math.floor(height / MAX_HEIGHT);

    for (let y = 0; y < MAX_HEIGHT; y++) {
      for (let x = 0; x < MAX_WIDTH; x++) {
        const index = terrain[positionToIndex(x, y, MAX_WIDTH, MAX_HEIGHT)];
        const color = TILESET_COLORS[index] || "#000000";

        context.fillStyle = color;
        context.fillRect(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
      }
    }
  }, [canvasRef, terrain, width, height]);

  return (
    <canvas ref={canvasRef} style={{ width, height }} className="pixelated rounded-sm" />
  );
};
