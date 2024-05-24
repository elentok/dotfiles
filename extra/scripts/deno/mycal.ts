#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import chalk from "npm:chalk"
import dayjs from "npm:dayjs"
import { center } from "./lib/utils.ts"

const FRIDAY = 5
const SATURDAY = 6
const TODAY = new Date()

function main(): void {
  const date = Deno.args.length > 0 ? dayjs(Deno.args[0]) : dayjs()
  const month = createMonth(date)
  console.info()
  printMonth(prevMonth(month))
  printMonth(month)
  printMonth(nextMonth(month))
}

interface Month {
  start: dayjs.Dayjs
  weeks: Week[]
}

interface Week {
  days: Array<dayjs.Dayjs | undefined>
}

function createMonth(date: dayjs.ConfigType) {
  const d = dayjs(date)
  const start = d.startOf("month")
  return {
    start,
    weeks: buildWeeks(start),
  }
}

function printMonth({ start, weeks }: Month): void {
  const date = new Intl.DateTimeFormat(undefined, {
    month: "short",
    year: "numeric",
  }).format(
    start.toDate(),
  )
  console.info(chalk.green(center(date, 27)))

  console.info("Sun Mon Tue Wed Thu Fri Sat")
  weeks.forEach(printWeek)
  console.info()
}

function nextMonth({ start }: Month): Month {
  return createMonth(start.add(1, "month"))
}

function prevMonth({ start }: Month): Month {
  return createMonth(start.subtract(1, "month"))
}

function buildWeeks(start: dayjs.Dayjs): Week[] {
  let week: Week = { days: [] }
  let date = start.startOf("week")
  const weeks: Week[] = []

  while (date < start) {
    week.days.push(undefined)
    date = date.add(1, "day")
  }

  while (date.isSame(start, "month")) {
    week.days.push(date)

    if (date.day() === SATURDAY) {
      weeks.push(week)
      week = { days: [] }
    }

    date = date.add(1, "day")
  }

  if (week.days.length > 0) {
    weeks.push(week)
  }

  return weeks
}

function printWeek({ days }: Week): void {
  console.info(
    days
      .map((day) => {
        if (day == null) return "   "
        return formatDay(day)
      })
      .join(" "),
  )
}

function formatDay(day: dayjs.Dayjs): string {
  const text = day.date().toString().padStart(3)

  if (day.isSame(TODAY, "day")) {
    return chalk.red(text)
  }

  if (isWeekend(day)) {
    return chalk.gray(text)
  }

  return text
}

function isWeekend(day: dayjs.Dayjs): boolean {
  return day.day() >= FRIDAY
}

main()
