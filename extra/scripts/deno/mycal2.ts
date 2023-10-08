#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import chalk from "npm:chalk"
import { center } from "./lib/utils.ts"
import { addToDate, isSameDay, moveDate } from "./lib/date.ts"

const FRIDAY = 5
const SATURDAY = 6
const TODAY = new Date()

function main(): void {
  const date = Deno.args.length > 0 ? new Date(Date.parse(Deno.args[0])) : new Date()
  const month = new Month(date)
  console.info()
  month.prev().print()
  month.print()
  month.next().print()
}

function startOf(date: Date, unit: "week" | "month") {
  const newDate = new Date(date)

  switch (unit) {
    case "week":
      newDate.setDate(newDate.getDate() - newDate.getDay())
      break

    case "month":
      newDate.setDate(1)
      break
  }

  return newDate
}

class Month {
  private start: Date
  private weeks: Week[] = []

  constructor(date: Date) {
    this.start = startOf(date, "month")
    this.buildWeeks()
  }

  public print(): void {
    const date = new Intl.DateTimeFormat(undefined, { month: "short", year: "numeric" }).format(
      new Date()
    )
    console.info(chalk.green(center(date, 27)))

    console.info("Sun Mon Tue Wed Thu Fri Sat")
    this.weeks.forEach((week) => console.info(week.pretty()))
    console.info()
  }

  public next(): Month {
    return new Month(moveDate(this.start, 1, "month"))
  }

  public prev(): Month {
    return new Month(moveDate(this.start, -1, "month"))
  }

  private buildWeeks(): void {
    let week = new Week()
    const date = startOf(this.start, "week")

    while (date < this.start) {
      week.days.push(undefined)
      addToDate(date, 1, "day")
    }

    while (date.getMonth() === this.start.getMonth()) {
      week.days.push(new Day(date))

      if (date.getDay() === SATURDAY) {
        this.weeks.push(week)
        week = new Week()
      }

      addToDate(date, 1, "day")
    }

    if (week.days.length > 0) {
      this.weeks.push(week)
    }
  }
}

class Week {
  public days: Array<Day | undefined> = []

  public pretty(): string {
    return this.days
      .map((day) => {
        if (day == null) return "   "
        return day.pretty()
      })
      .join(" ")
  }
}

class Day {
  public date: Date

  constructor(date: Date) {
    this.date = new Date(date)
  }

  public pretty(): string {
    if (this.isToday()) {
      return chalk.red(this.text())
    }

    if (this.isWeekend()) {
      return chalk.gray(this.text())
    }

    return this.text()
  }

  public isToday(): boolean {
    return isSameDay(this.date, TODAY)
  }

  public isWeekend(): boolean {
    return this.date.getDay() >= FRIDAY
  }

  public text(): string {
    return this.date.getDate().toString().padStart(3)
  }
}

main()
