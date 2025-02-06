import { privateKeyToAccount } from "viem/accounts";
import { setup } from "./mud/setup";
import { setupKeepers } from "./keepers";

export const PRIVATE_KEY = `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`;
const account = privateKeyToAccount(PRIVATE_KEY);

export async function main() {
  const setupResult = await setup(account);
  await setupKeepers(setupResult);
}

main();
