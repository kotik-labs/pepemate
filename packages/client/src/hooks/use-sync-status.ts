import { initialProgress } from "@latticexyz/store-sync/internal";
import { SyncStep } from "@latticexyz/store-sync";
import { useMemo } from "react";
import { useComponentValue } from "@latticexyz/react";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { components } from "@/lib/mud/recs";
import { ComponentValue } from "@latticexyz/recs";

export type SyncStatusResult = ComponentValue<
  (typeof components)["SyncProgress"]["schema"]
> & { isLive: boolean };

export function useSyncStatus(): SyncStatusResult {
  const progress = useComponentValue(
    components.SyncProgress,
    singletonEntity,
    initialProgress
  );

  return useMemo(
    () => ({
      ...progress,
      isLive: progress.step === SyncStep.LIVE,
    }),
    [progress]
  );
}
