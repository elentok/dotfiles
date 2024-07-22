#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run --allow-write

import { weekOfYear } from "jsr:@std/datetime"
import { existsSync } from "jsr:@std/fs"

function main() {
  const root = Deno.args.length > 0 ? Deno.args[0] : Deno.cwd()

  const sunday = findSundayOfCurrentWeek()
  const week = weekOfYear(sunday) + 1

  const formatter = new Intl.DateTimeFormat(undefined, { month: "short" })
  const month = formatter.format(sunday)
  const monthLowercase = month.toLowerCase()
  const year = sunday.getFullYear()

  const week2digits = week.toString().padStart(2, "0")
  const day2digits = sunday.getDate().toString().padStart(2, "0")
  const weeklyDir = `${root}/weekly`
  const yearDir = `${weeklyDir}/${year}/`
  const filename =
    `${yearDir}/${year}-week${week2digits}-${monthLowercase}-${day2digits}.md`

  if (!existsSync(weeklyDir)) {
    return
  }

  if (!existsSync(yearDir)) {
    Deno.mkdirSync(yearDir, { recursive: true })
  }

  if (!existsSync(filename)) {
    const title =
      `# Week ${week}, ${sunday.getFullYear()} (${month} ${sunday.getDate()})`

    Deno.writeTextFileSync(filename, title)
  }

  console.info(filename)
}

function findSundayOfCurrentWeek(): Date {
  const date = new Date()
  date.setDate(date.getDate() - date.getDay())
  return date
}

main()
