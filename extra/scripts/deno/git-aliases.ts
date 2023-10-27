#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { Table } from "npm:console-table-printer"
import { execSync } from "./lib/utils.ts"

interface Alias {
  name: string
  value: string
}

function main() {
  const aliases = getAliases()

  const table = new Table({
    columns: [
      { name: "name", title: "Name", alignment: "left" },
      { name: "value", title: "Value", alignment: "left", maxLen: 40 },
    ],
  })

  aliases.forEach((alias, index) => {
    table.addRow(alias, { color: index % 2 == 0 ? "cyan" : undefined })
  })
  table.printTable()
}

function getAliases(): Alias[] {
  return execSync("git", { args: ["alias"] })
    .trim()
    .split("\n")
    .map(parseAlias)
}

function parseAlias(line: string): Alias {
  line = line.replace(/^alias\./, "")
  const index = line.indexOf(" ")
  return {
    name: line.substring(0, index),
    value: line.substring(index + 1),
  }
}

main()
