#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { weekOfYear } from "https://deno.land/std@0.213.0/datetime/mod.ts"
import { existsSync } from "https://deno.land/std/fs/mod.ts"

function main() {
  const sunday = findSundayOfCurrentWeek()
  const week = weekOfYear(sunday) + 1
  console.log(week)

  const formatter = new Intl.DateTimeFormat(undefined, { month: "short" })
  const month = formatter.format(sunday)
  const monthLowercase = month.toLowerCase()

  const week2digits = week.toString().padStart(2, "0")
  const filename =
    `${sunday.getFullYear()}-week-${week2digits}-${monthLowercase}-${sunday.getDate()}.md`

  if (!existsSync(filename)) {
    const title =
      `# Week ${week}, ${sunday.getFullYear()} (${month} ${sunday.getDate()})`
    console.info(title)
  }

  console.info(filename)
}

function findSundayOfCurrentWeek(): Date {
  const date = new Date()
  date.setDate(date.getDate() - date.getDay())
  return date
}

main()
