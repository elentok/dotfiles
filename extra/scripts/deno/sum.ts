#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { getStdInput } from "./utils.ts"

function main() {
  const input = getStdInput().trim()

  const sum = input.split("\n").reduce(
    (sum, line) => sum + lineValue(line),
    0,
  )

  if (Deno.args.includes("-e") || Deno.args.includes("--echo")) {
    console.info(`${input}\n`)
  }

  console.info(`= ${sum}`)
}

function lineValue(line: string): number {
  line = line.trim()
  return line.length === 0 ? 0 : Number(line.split(" ")[0])
}

main()
