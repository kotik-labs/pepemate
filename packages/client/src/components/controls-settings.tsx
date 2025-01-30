"use client";

import { Button } from "@/components/ui/button";
import { useControls } from "@/hooks/use-controls";
import { Inputs } from "@/constants";

export default function GameControlsSettings() {
  const { controls, listen, listeningFor } = useControls();

  return (
    <div className="w-full flex flex-col gap-2">
      {Object.entries(controls).map(([action, key]) => (
        <div key={action} className="flex items-center justify-between">
          <span className="capitalize">{action}:</span>
          <Button
            onClick={() => listen(action as Inputs)}
            variant={"secondary"}
          >
            {listeningFor === action ? "Press any key" : key}
          </Button>
        </div>
      ))}
    </div>
  );
}
