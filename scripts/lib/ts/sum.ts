import { readFileSync } from "fs";
import { runInContext, createContext } from "vm";

const context = createContext();

function lineValue(line: string): number {
  if (/^\s*$/.test(line)) return 0;

  const valueString = line.split(" ")[0];
  return runInContext(valueString, context);
}

export function sum(lines: string[]): number {
  return lines.reduce((sum, line) => sum + lineValue(line), 0);
}

const input = readFileSync(0, "utf-8").trim().toString();

const totalSum = sum(input.split("\n")).toFixed(3);
console.info(`${input}

= ${totalSum}`);
