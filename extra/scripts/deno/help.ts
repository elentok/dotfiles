#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run --allow-sys

import * as path from "jsr:@std/path"
import { bold, green } from "jsr:@std/fmt/colors"
import { expandGlob } from "jsr:@std/fs/expand-glob"

const HELP_FILENAME = path.join(Deno.env.get("DOTF") || "", "docs", "help.md")
const LOCAL_HELP_GLOB = path.join(Deno.env.get("DOTP") || "", "docs", "*.md")

export async function help(): Promise<void> {
  const query = Deno.args[0]

  if (query === "e") {
    const cmd = new Deno.Command("nvim", { args: [HELP_FILENAME] })
    cmd.spawn()
  } else {
    console.info(findSections(HELP_FILENAME, query).join("\n"))

    const filenames = await Array.fromAsync(expandGlob(LOCAL_HELP_GLOB))
    for (const filename of filenames) {
      console.info(findSections(filename.path, query).join("\n"))
    }
  }
}

function findSections(filename: string, query?: string): string[] {
  const sections: string[] = []
  let sectionLines: string[] = []

  Deno.readTextFileSync(filename)
    .split("\n")
    .forEach((line) => {
      if (isBeginningOfSection(line)) {
        addSection(sections, sectionLines.join("\n"), query)
        sectionLines = [line]
      } else {
        sectionLines.push(line)
      }
    })

  addSection(sections, sectionLines.join("\n"), query)

  return sections
}

function isBeginningOfSection(line: string): boolean {
  return /^#/.test(line)
}

function addSection(sections: string[], section: string, query?: string): void {
  if (/^\s*$/.test(section)) return

  if (query == null) {
    sections.push(section)
  } else if (isMatch(section, query)) {
    sections.push(highlightQuery(section, query))
  }
}

function isMatch(section: string, query: string): boolean {
  return new RegExp(query, "i").test(section)
}

function highlightQuery(section: string, query: string): string {
  const highlight = bold(green(query))
  return section.replace(new RegExp(query, "ig"), highlight)
}

help()
