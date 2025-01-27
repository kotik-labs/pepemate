/*
 * Creates components for use by the client.
 *
 * By default it returns the components from setupNetwork.ts, those which are
 * automatically inferred from the mud.config.ts table definitions.
 *
 * However, you can add or override components here as needed. This
 * lets you add user defined components, which may or may not have
 * an onchain component.
 */
import { defineComponent, Type } from "@latticexyz/recs";
import { SetupNetworkResult } from "./setupNetwork";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
  world,
  components,
}: SetupNetworkResult) {
  return {
    ...components,
    // add your client components or overrides here
    // Position: overridableComponent(components.Position),
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
}
