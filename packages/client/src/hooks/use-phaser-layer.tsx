import Phaser from "phaser";
import { throttle } from "lodash";
import { useCallback, useLayoutEffect, useMemo, useRef, useState } from "react";
import useResizeObserver, { ResizeHandler } from "use-resize-observer";
import { createPhaserLayer } from "@/phaser/create-phaser-layer";
import { NetworkLayer } from "@/hooks/use-network-layer";
import { usePromiseValue } from "@/hooks/use-promise-value";
import { phaserConfig } from "@/phaser/configure-phaser";
import {
  TILE_WIDTH,
  TILE_HEIGHT,
  MAX_WIDTH,
  MAX_HEIGHT,
  DEFAULT_SCALE,
} from "@/constants";

const createContainer = () => {
  const container = document.createElement("div");
  container.style.width = `${TILE_WIDTH * MAX_WIDTH * DEFAULT_SCALE}px`;
  container.style.height = `${TILE_HEIGHT * MAX_HEIGHT * DEFAULT_SCALE}px`;
  container.style.pointerEvents = "all";
  container.style.overflow = "hidden";
  return container;
};

type Props = {
  networkLayer: NetworkLayer | null;
};

export const usePhaserLayer = ({ networkLayer }: Props) => {
  const parentRef = useRef<HTMLElement | null>(null);
  const [{ width, height }, setSize] = useState({ width: 0, height: 0 });

  const { phaserLayerPromise, container } = useMemo(() => {
    if (!networkLayer) return { phaserLayerPromise: null, container: null };

    let container;
    if (parentRef.current && parentRef.current.children.length === 0) {
      container = createContainer()
      parentRef.current.appendChild(container);
    } else {
      container = parentRef.current?.children[0];
    }

    return {
      container,
      phaserLayerPromise: createPhaserLayer(networkLayer, {
        ...phaserConfig,
        scale: {
          ...phaserConfig.scale,
          parent: container,
          mode: Phaser.Scale.NONE,
          width,
          height,
        },
      }),
    };

    // We don't want width/height to recreate phaser layer, so we ignore linter
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [networkLayer]);

  useLayoutEffect(() => {
    return () => {
      phaserLayerPromise?.then((phaserLayer) =>
        phaserLayer.network.world.dispose()
      );
      container?.remove();
    };
  }, [container, phaserLayerPromise]);

  const phaserLayer = usePromiseValue(phaserLayerPromise);

  const onResize = useMemo<ResizeHandler>(() => {
    return throttle(({ width, height }) => {
      setSize({ width: width ?? 0, height: height ?? 0 });
    }, 500);
  }, []);

  useResizeObserver({
    ref: container,
    onResize,
  });

  const ref = useCallback(
    (el: HTMLElement | null) => {
      parentRef.current = el;
      if (container) {
        if (parentRef.current) {
          parentRef.current.appendChild(container);
        } else {
          container.remove();
        }
      }
    },
    [container]
  );

  return useMemo(() => ({ ref, phaserLayer }), [ref, phaserLayer]);
};
