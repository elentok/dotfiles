#!/usr/bin/env node

import * as fs from "node:fs"
import dayjs from "dayjs"

const args = process.argv.slice(2)

function main() {
  if (args.length < 1) {
    console.info("Usage: habits-create <habits-list.md> [date]")
  }

  const habits = loadHabits(args[0])
  const start = dayjs(args[1]).startOf("month")

  console.info(`# ${start.format("MMMM YYYY")} Habits`)
  console.info()

  writeTables(habits, start)
}

function writeTables(habits: string[], start: dayjs.Dayjs) {
  let columns: string[] = []
  let date = dayjs(start)
  while (date.month() === start.month()) {
    if (
      date.day() === 0 && date.date() !== start.date() &&
      date.add(1, "day").month() === start.month()
    ) {
      console.info("\n---\n")
      writeTable(habits, columns)
      columns = []
    }

    columns.push(date.format("DD ddd"))

    date = date.add(1, "day")
  }

  console.info("")

  if (columns.length > 0) {
    console.info("\n---\n")
    writeTable(habits, columns)
  }
}

function writeTable(habits: string[], columns: string[]) {
  console.info(["", "Habit", ...columns, ""].join(" | ").trim())
  console.info(["", "---", ...columns.map((_) => "---"), ""].join(" | ").trim())

  const emptyColumns = columns.map(() => "")

  for (const habit of habits) {
    console.info(["", habit, ...emptyColumns, ""].join(" | ").trim())
  }
}

function loadHabits(filename: string) {
  const lines = fs.readFileSync(filename, "utf8").split("\n")

  return lines.filter((line) => line.startsWith("- ")).map((line) =>
    line.substring(2)
  )
}

main()
