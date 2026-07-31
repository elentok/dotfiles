#!/usr/bin/env node

import * as fs from "node:fs"
import { parse } from "yaml"
import pc from "picocolors"

interface Config {
  services: Record<string, { command?: string }>
}

const { services } = parse(
  fs.readFileSync("docker-compose.yml", "utf8"),
) as Config

for (const [name, service] of Object.entries(services)) {
  if (service.command) {
    const command = service.command.replace(/\n/g, " ")
    console.info(`${name} - ${pc.gray(command)}`)
  } else {
    console.info(name)
  }
}
