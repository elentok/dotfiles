#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { green } from "jsr:@std/fmt/colors"

function main() {
  if (!fileExists("package.json")) {
    console.error("Error: No package.json file")
    Deno.exit(1)
  }

  const scripts = JSON.parse(Deno.readTextFileSync("package.json")).scripts

  if (!scripts) {
    console.error("Error: package.json file has no scripts")
    Deno.exit(2)
  }

  let nameColumnWidth = 0

  Object.keys(scripts).forEach((name) => {
    if (name.length > nameColumnWidth) {
      nameColumnWidth = name.length
    }
  })

  Object.keys(scripts).forEach((name) => {
    const prettyName = green(name.padEnd(nameColumnWidth))
    console.info(`${prettyName}  - ${scripts[name]}`)
  })
}

async function fileExists(path: string): Promise<boolean> {
  try {
    const stat = await Deno.stat(path)
    return stat.isFile // Ensure it's a file (not a directory or other type)
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      return false
    }
    throw error // Rethrow other errors
  }
}

main()
