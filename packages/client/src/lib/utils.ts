import { DEFAULT_KEYBINDINGS } from "@/constants";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import { Hex } from "viem";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const rngChoice = <T>(choices: T[]): T => {
  const index = Math.floor(Math.random() * choices.length);
  return choices[index];
};

export const shorten = (value: Hex, charsCount: number = 4) => {
  const regex = new RegExp(
    String.raw`^(0x[a-zA-Z0-9]{${charsCount}})[a-zA-Z0-9]+([a-zA-Z0-9]{${charsCount}})$`
  );
  const match = value.match(regex);
  if (!match) return value;
  return match[1] + "\u2026" + match[2];
};

export const getBrowserControls = (): typeof DEFAULT_KEYBINDINGS => {
  const controls = localStorage.getItem("controls");
  return controls ? JSON.parse(controls) : DEFAULT_KEYBINDINGS;
};
