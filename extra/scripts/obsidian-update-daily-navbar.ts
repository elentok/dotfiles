#!/usr/bin/env -S bun run

import { readdir, readFile, stat, writeFile } from "node:fs/promises"
import { join, resolve } from "node:path"
import { homedir } from "node:os"

const DAILY_NOTE_RE = /^\d{4}-\d{2}-\d{2}\.md$/
const DEFAULT_DAILY_ROOT = resolve(homedir(), "notes/daily")
const MONTH_FORMATTER = new Intl.DateTimeFormat("en-US", {
  month: "long",
  timeZone: "UTC",
})

type Options = {
  dryRun: boolean
  root: string
}

async function main() {
  const options = parseArgs(process.argv.slice(2))
  const files = await collectDailyNotes(options.root)

  let updated = 0

  for (const file of files) {
    const result = await updateDailyNavbar(file, options.dryRun)
    if (options.dryRun) {
      console.info(`${file}: ${result.navbar}`)
    }
    if (result.didUpdate) {
      updated += 1
      if (!options.dryRun) {
        console.info(`updated ${file}`)
      }
    }
  }

  console.info(
    `${options.dryRun ? "would update" : "updated"} ${updated}/${files.length} daily notes`,
  )
}

function parseArgs(args: string[]): Options {
  let dryRun = false
  let root = DEFAULT_DAILY_ROOT

  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index]

    if (arg === "--dry-run") {
      dryRun = true
      continue
    }

    if (arg === "--root") {
      const value = args[index + 1]
      if (!value) {
        throw new Error("--root requires a path")
      }

      root = resolve(value)
      index += 1
      continue
    }

    if (arg === "--help" || arg === "-h") {
      printHelp()
      process.exit(0)
    }

    throw new Error(`unknown argument: ${arg}`)
  }

  return { dryRun, root }
}

function printHelp() {
  console.info(
    [
      "Usage: obsidian-update-daily-navbar.ts [--dry-run] [--root <daily-dir>]",
      "",
      `Defaults to: ${DEFAULT_DAILY_ROOT}`,
    ].join("\n"),
  )
}

async function collectDailyNotes(root: string): Promise<string[]> {
  const rootStat = await stat(root).catch(() => null)
  if (!rootStat?.isDirectory()) {
    throw new Error(`daily root does not exist or is not a directory: ${root}`)
  }

  const files: string[] = []
  const years = await readdir(root, { withFileTypes: true })

  for (const yearEntry of years) {
    if (!yearEntry.isDirectory()) {
      continue
    }

    const yearDir = join(root, yearEntry.name)
    const months = await readdir(yearDir, { withFileTypes: true })

    for (const monthEntry of months) {
      if (!monthEntry.isDirectory()) {
        continue
      }

      const monthDir = join(yearDir, monthEntry.name)
      const entries = await readdir(monthDir, { withFileTypes: true })

      for (const entry of entries) {
        if (!entry.isFile() || !DAILY_NOTE_RE.test(entry.name)) {
          continue
        }

        files.push(join(monthDir, entry.name))
      }
    }
  }

  files.sort()
  return files
}

async function updateDailyNavbar(
  file: string,
  dryRun: boolean,
): Promise<{ didUpdate: boolean; navbar: string }> {
  const content = await readFile(file, "utf8")
  const lines = content.split(/\r?\n/)
  const firstLine = lines[0] ?? ""

  const date = parseDailyNoteDate(file)
  const navbar = buildNavbar(date)

  if (firstLine === navbar) {
    return { didUpdate: false, navbar }
  }

  lines[0] = navbar
  const nextContent = lines.join("\n")

  if (!dryRun) {
    await writeFile(file, nextContent, "utf8")
  }

  return { didUpdate: true, navbar }
}

function parseDailyNoteDate(file: string): Date {
  const filename = file.split("/").at(-1)
  if (!filename) {
    throw new Error(`unable to determine filename for ${file}`)
  }

  const match = filename.match(/^(\d{4})-(\d{2})-(\d{2})\.md$/)
  if (!match) {
    throw new Error(`invalid daily note filename: ${file}`)
  }

  const [, year, month, day] = match
  return new Date(Date.UTC(Number(year), Number(month) - 1, Number(day), 12))
}

function buildNavbar(date: Date): string {
  const yesterday = addDays(date, -1)
  const tomorrow = addDays(date, 1)

  return [
    "•",
    createLink(formatDayTitle(yesterday), `daily/${formatDayPath(yesterday)}`),
    "•",
    createLink(formatMonthTitle(date), `monthly/${formatMonthPath(date)}`),
    "•",
    createLink(formatDayTitle(tomorrow), `daily/${formatDayPath(tomorrow)}`),
    "•",
  ].join(" ")
}

function createLink(title: string, link: string): string {
  return `[[${link}|${title}]]`
}

function formatDayTitle(date: Date): string {
  return formatDate(date)
}

function formatDayPath(date: Date): string {
  return `${date.getUTCFullYear()}/${pad2(date.getUTCMonth() + 1)}/${formatDate(date)}`
}

function formatMonthPath(date: Date): string {
  return `${date.getUTCFullYear()}/${date.getUTCFullYear()}-${pad2(date.getUTCMonth() + 1)}`
}

function formatMonthTitle(date: Date): string {
  return MONTH_FORMATTER.format(date)
}

function formatDate(date: Date): string {
  return [
    date.getUTCFullYear(),
    pad2(date.getUTCMonth() + 1),
    pad2(date.getUTCDate()),
  ].join("-")
}

function addDays(date: Date, days: number): Date {
  const copy = new Date(date)
  copy.setUTCDate(copy.getUTCDate() + days)
  return copy
}

function pad2(value: number): string {
  return value.toString().padStart(2, "0")
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error)
  console.error(message)
  process.exit(1)
})
