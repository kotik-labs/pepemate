import { Inputs } from "@/constants";
import { getBrowserControls } from "@/lib/utils";
import { useCallback, useEffect, useState } from "react";

//@TODO:
const keyMapping: Record<string, string> = {
  " ": "SPACE",
  ARROWUP: "UP",
  ARROWDOWN: "DOWN",
  ARROWLEFT: "LEFT",
  ARROWRIGHT: "RIGHT",
};

export const useControls = () => {
  const [controls, setControls] = useState(getBrowserControls());
  const [listeningFor, setListeningFor] = useState<Inputs | null>(null);

  useEffect(() => {
    localStorage.setItem("controls", JSON.stringify(controls));
  }, [controls]);

  const handleKeyPress = useCallback(
    (event: KeyboardEvent) => {
      if (listeningFor) {
        event.preventDefault();
        const key = event.key.toUpperCase();
        const mappedKey = keyMapping[key] || key;
        setControls((prev) => ({
          ...prev,
          [listeningFor]: mappedKey,
        }));
        setListeningFor(null);
      }
    },
    [listeningFor]
  );

  useEffect(() => {
    window.addEventListener("keydown", handleKeyPress);
    return () => {
      window.removeEventListener("keydown", handleKeyPress);
    };
  }, [handleKeyPress]);

  const listen = (action: Inputs) => {
    setListeningFor(action);
  };

  return { controls, listen, listeningFor };
};
