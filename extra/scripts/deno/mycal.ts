#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import chalk from "npm:chalk"
import dayjs from "npm:dayjs"
import { center } from "./lib/utils.ts"

const FRIDAY = 5
const SATURDAY = 6
const TODAY = new Date()

function main(): void {
  const date = Deno.args.length > 0
    ? new Date(Date.parse(Deno.args[0]))
    : new Date()
  const month = new Month(date)
  console.info()
  month.prev().print()
  month.print()
  month.next().print()
}

class Month {
  private start: dayjs.Dayjs
  private weeks: Week[] = []

  constructor(date: dayjs.ConfigType) {
    const d = dayjs(date)
    this.start = d.startOf("month")
    this.buildWeeks()
  }

  public print(): void {
    const date = new Intl.DateTimeFormat(undefined, {
      month: "short",
      year: "numeric",
    }).format(
      this.start.toDate(),
    )
    console.info(chalk.green(center(date, 27)))

    console.info("Sun Mon Tue Wed Thu Fri Sat")
    this.weeks.forEach((week) => console.info(week.pretty()))
    console.info()
  }

  public next(): Month {
    return new Month(this.start.add(1, "month"))
  }

  public prev(): Month {
    return new Month(this.start.subtract(1, "month"))
  }

  private buildWeeks(): void {
    let week = new Week()
    let date = this.start.startOf("week")

    while (date < this.start) {
      week.days.push(undefined)
      date = date.add(1, "day")
    }

    while (date.isSame(this.start, "month")) {
      week.days.push(new Day(date))

      if (date.day() === SATURDAY) {
        this.weeks.push(week)
        week = new Week()
      }

      date = date.add(1, "day")
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
  public date: dayjs.Dayjs

  constructor(date: dayjs.ConfigType) {
    this.date = dayjs(date)
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
    return this.date.isSame(TODAY, "day")
  }

  public isWeekend(): boolean {
    return this.date.day() >= FRIDAY
  }

  public text(): string {
    return this.date.date().toString().padStart(3)
  }
}

main()
