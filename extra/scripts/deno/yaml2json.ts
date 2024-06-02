#!/usr/bin/env -S deno run --allow-env --allow-read --allow-write

import yaml from "npm:yaml"

if (Deno.args.length < 1) {
  console.info("Usage:\n")
  console.info("  yaml2json <input.yml> [output.json]")
  Deno.exit(1)
}

const input = Deno.args[0]
const output = Deno.args[1] ?? input.replace(/\.ya?ml$/, "") + ".json"

console.info(`Converting ${input}`)
console.info(`        to ${output}`)

const data = yaml.parse(Deno.readTextFileSync(input))
const json = JSON.stringify(data, null, 2)
Deno.writeTextFileSync(output, json)
