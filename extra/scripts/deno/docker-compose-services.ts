#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { parse } from "jsr:@std/yaml"
import { gray } from "jsr:@std/fmt/colors"

interface Config {
  services: Record<string, { command?: string }>
}

const { services } = parse(
  Deno.readTextFileSync("docker-compose.yml"),
) as Config

for (const [name, service] of Object.entries(services)) {
  if (service.command) {
    const command = service.command.replace(/\n/g, " ")
    console.info(`${name} - ${gray(command)}`)
  } else {
    console.info(name)
  }
}
