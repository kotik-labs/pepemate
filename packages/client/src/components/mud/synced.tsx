import { ReactNode } from "react";
import { SyncStatusResult, useSyncStatus } from "@/hooks/use-sync-status";

export type Props = {
  children: ReactNode;
  fallback?: (props: SyncStatusResult) => ReactNode;
};

export function Synced({ children, fallback }: Props) {
  const status = useSyncStatus();
  return status.isLive ? children : fallback?.(status);
}
