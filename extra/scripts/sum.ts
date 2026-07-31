#!/usr/bin/env node

import { getStdInput } from "./utils.ts"

const args = process.argv.slice(2)

function main() {
  const input = getStdInput().trim()

  const sum = input.split("\n").reduce(
    (sum, line) => sum + lineValue(line),
    0,
  )

  if (args.includes("-e") || args.includes("--echo")) {
    console.info(`${input}\n`)
  }

  console.info(`= ${sum}`)
}

function lineValue(line: string): number {
  line = line.trim()
  return line.length === 0 ? 0 : Number(line.split(" ")[0])
}

main()
