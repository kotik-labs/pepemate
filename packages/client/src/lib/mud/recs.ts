import { createWorld, defineComponent, Type } from "@latticexyz/recs";
import { createSyncAdapter } from "@latticexyz/store-sync/recs";
import config from "contracts/mud.config";

export const world = createWorld();
export const { syncAdapter, components: systemComponents } = createSyncAdapter({
  world,
  config,
});

export const components = {
  ...systemComponents,
  LocalSession: defineComponent(
    world,
    { id: Type.String },
    { id: "LocalSession" }
  ),
  Cursor: defineComponent(
    world,
    {
      x: Type.Number,
      y: Type.Number,
    },
    {
      id: "Cursor",
    }
  ),
};

export type ClientComponents = typeof components;
