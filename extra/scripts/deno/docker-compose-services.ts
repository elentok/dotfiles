#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import YAML from "npm:yaml"
import chalk from "npm:chalk"

interface Config {
  services: Record<string, { command?: string }>
}

const { services } = YAML.parse(
  Deno.readTextFileSync("docker-compose.yml"),
) as Config

for (const [name, service] of Object.entries(services)) {
  if (service.command) {
    const command = service.command.replace(/\n/g, " ")
    console.info(`${name} - ${chalk.grey(command)}`)
  } else {
    console.info(name)
  }
}
