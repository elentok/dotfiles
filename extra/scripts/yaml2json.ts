#!/usr/bin/env node

import * as fs from "node:fs"
import { parse } from "yaml"

const args = process.argv.slice(2)

if (args.length < 1) {
  console.info("Usage:\n")
  console.info("  yaml2json <input.yml> [output.json]")
  process.exit(1)
}

const input = args[0]
const output = args[1] ?? input.replace(/\.ya?ml$/, "") + ".json"

const data = parse(fs.readFileSync(input, "utf8"))
const json = JSON.stringify(data, null, 2)

if (output === "-") {
  console.info(json)
} else {
  console.info(`Converting ${input}`)
  console.info(`        to ${output}`)

  fs.writeFileSync(output, json)
}
