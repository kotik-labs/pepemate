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

export const shorten = (value: Hex) => {
  const match = value.match(
    /^(0x[a-zA-Z0-9]{4})[a-zA-Z0-9]+([a-zA-Z0-9]{4})$/
  );
  if (!match) return value;
  return match[1] + "\u2026" + match[2];
};
