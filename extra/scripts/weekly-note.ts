#!/usr/bin/env node

import * as fs from "node:fs"

const args = process.argv.slice(2)

function weekOfYear(date: Date): number {
  const target = new Date(date.getTime())
  const dayNumber = (date.getDay() + 6) % 7
  target.setDate(target.getDate() - dayNumber + 3)
  const firstThursday = new Date(target.getFullYear(), 0, 4)
  const diff = target.getTime() - firstThursday.getTime()
  return 1 + Math.round(diff / (7 * 24 * 60 * 60 * 1000))
}

function main() {
  const root = args.length > 0 ? args[0] : process.cwd()

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

  if (!fs.existsSync(weeklyDir)) {
    return
  }

  if (!fs.existsSync(yearDir)) {
    fs.mkdirSync(yearDir, { recursive: true })
  }

  if (!fs.existsSync(filename)) {
    const title =
      `# Week ${week}, ${sunday.getFullYear()} (${month} ${sunday.getDate()})`

    fs.writeFileSync(filename, title)
  }

  console.info(filename)
}

function findSundayOfCurrentWeek(): Date {
  const date = new Date()
  date.setDate(date.getDate() - date.getDay())
  return date
}

main()
