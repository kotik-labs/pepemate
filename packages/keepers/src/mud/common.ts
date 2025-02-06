import worlds from "contracts/worlds.json";
import worldAbi from "contracts/out/IWorld.sol/IWorld.abi.json";
import {
  createWalletClient,
  fallback,
  getContract,
  http,
  webSocket,
  Chain,
  Account,
  GetContractReturnType,
  Client,
  Transport,
  PublicClient,
} from "viem";

import { transportObserver } from "@latticexyz/common";
import { transactionQueue } from "@latticexyz/common/actions";
import { chains } from "./wagmi-config";

export const chainId = Number(process.env.CHAIN_ID) || 31337;
export const worldAddress = worlds[chainId]?.address;
export const startBlock = BigInt(worlds[chainId]?.blockNumber ?? 0n);

const supportedChainIds = chains.map((c) => c.id);
export type SupportedChains = (typeof supportedChainIds)[number];

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

export function getChainId(): SupportedChains {
  return getChain().id as SupportedChains;
}

export type WorldContract = GetContractReturnType<
  typeof worldAbi,
  {
    public: Client<Transport, Chain>;
    wallet: Client<Transport, Chain, Account>;
  }
>;

export function getWorldContract(
  client: PublicClient,
  account: Account
): WorldContract {
  const walletClient = createWalletClient({
    chain: client.chain,
    transport: transportObserver(fallback([webSocket(), http()])),
    pollingInterval: 1000,
    account,
  }).extend(transactionQueue());

  const worldContract = getContract({
    address: getWorldAddress(),
    abi: worldAbi,
    client: { public: client, wallet: walletClient },
  });

  return worldContract;
}
