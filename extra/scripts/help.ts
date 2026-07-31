#!/usr/bin/env node

import * as fs from "node:fs"
import * as path from "node:path"
import { spawn } from "node:child_process"
import fg from "fast-glob"
import pc from "picocolors"

const args = process.argv.slice(2)

const HELP_FILENAME = path.join(process.env.DOTF || "", "docs", "help.md")
const LOCAL_HELP_GLOB = path.join(process.env.DOTP || "", "docs", "*.md")

export async function help(): Promise<void> {
  const query = args[0]

  if (query === "e") {
    spawn("nvim", [HELP_FILENAME], { stdio: "inherit" })
  } else {
    console.info(findSections(HELP_FILENAME, query).join("\n"))

    const filenames = await fg(LOCAL_HELP_GLOB)
    for (const filename of filenames) {
      console.info(findSections(filename, query).join("\n"))
    }
  }
}

function findSections(filename: string, query?: string): string[] {
  const sections: string[] = []
  let sectionLines: string[] = []

  fs.readFileSync(filename, "utf8")
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
  const highlight = pc.bold(pc.green(query))
  return section.replace(new RegExp(query, "ig"), highlight)
}

help()
