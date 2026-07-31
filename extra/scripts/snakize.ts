#!/usr/bin/env node

import * as fs from "node:fs"

const args = process.argv.slice(2)

function main() {
  const noop = !args.includes("-r")

  if (noop) {
    console.info()
    console.info('Simulating rename, to actually rename run with "-r"')
    console.info()
  }

  for (const filename of fs.readdirSync(".")) {
    const newName = snakize(filename)
    if (newName === filename) continue

    console.info(`Renaming "${filename}" to "${newName}"`)
    if (!noop) {
      fs.renameSync(filename, newName)
    }
  }
}

function snakize(name: string): string {
  return name.replace(/^([A-Z])/, (match) => match.toLowerCase())
    .replace(/[_-]?([A-Z])/g, (_match, char) => `-${char.toLowerCase()}`)
}

main()
