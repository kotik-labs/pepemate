import { AccountButton } from "@latticexyz/entrykit/internal";
import { Synced } from "@/components/mud/synced";
import { Clouds } from "@/components/clouds";
import { Outlet } from "react-router";

export function AppLayout() {
  return (
    <main className="fixed inset-0 grid place-items-center p-4 bg-blue-400">
      <div className="relative z-20">
        <Synced
          fallback={({ message, percentage }) => (
            <div>
              <span className="tabular-nums text-white">
                {message} ({percentage.toFixed(1)}%)…
              </span>
            </div>
          )}
        >
          <Outlet />
        </Synced>
      </div>
      <div className="fixed z-20 top-2 right-2">
        <AccountButton />
      </div>
      <div className="fixed z-0">
        <Clouds maxClouds={8} />
      </div>
    </main>
  );
}
