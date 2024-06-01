#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { Command } from "npm:commander@11.1.0"

const program = new Command()

program.command("setup").action(async () => {
  const { setup } = await import("./commands/setup.ts")
  setup()
})

program.parse()
