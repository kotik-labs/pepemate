import mudConfig from "contracts/mud.config";
import { rhodolite, garnet, redstone } from "@latticexyz/common/chains";
import { anvil } from "viem/chains";
import { Chain, Hex } from "viem";

export const chainId = import.meta.env.CHAIN_ID || 31337;
export const worldAddress = import.meta.env.WORLD_ADDRESS;
export const startBlock = import.meta.env.START_BLOCK;

export const url = new URL(window.location.href);

export const chains = [
  redstone,
  garnet,
  rhodolite,
  {
    ...anvil,
    contracts: {
      ...anvil.contracts,
      paymaster: {
        address: "0xf03E61E7421c43D9068Ca562882E98d1be0a6b6e",
      },
    },
    blockExplorers: {
      default: {} as never,
      worldsExplorer: {
        name: "MUD Worlds Explorer",
        url: "http://localhost:13690/anvil/worlds",
      },
    },
  },
] as const satisfies Chain[];

export type Entity = Hex;
export type Direction = (typeof mudConfig.enums.Direction)[number];

export function getWorldAddress() {
  if (!worldAddress) {
    throw new Error(
      "No world address configured. Is the world still deploying?"
    );
  }
  return worldAddress;
}

export function getChain(): Chain {
  const chain = chains.find((c) => c.id === chainId);
  if (!chain) {
    throw new Error(`No chain configured for chain ID ${chainId}.`);
  }
  return chain;
}
