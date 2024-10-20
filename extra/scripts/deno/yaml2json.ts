#!/usr/bin/env -S deno run --allow-env --allow-read --allow-write

import { parse } from "jsr:@std/yaml"

if (Deno.args.length < 1) {
  console.info("Usage:\n")
  console.info("  yaml2json <input.yml> [output.json]")
  Deno.exit(1)
}

const input = Deno.args[0]
const output = Deno.args[1] ?? input.replace(/\.ya?ml$/, "") + ".json"

const data = parse(Deno.readTextFileSync(input))
const json = JSON.stringify(data, null, 2)

if (output === "-") {
  console.info(json)
} else {
  console.info(`Converting ${input}`)
  console.info(`        to ${output}`)

  Deno.writeTextFileSync(output, json)
}
