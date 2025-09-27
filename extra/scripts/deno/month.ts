#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import dayjs from "npm:dayjs@1.11.18"

const start = dayjs(Deno.args[0]).startOf("month")

console.info(start.format("# MMMM YYYY"))
console.info()

const prevMonth = start.subtract(1, "month")
const prevName = prevMonth.format(
  prevMonth.year() === start.year() ? "MMM" : "MMM YYYY",
)
const prevMarkdown = `[[${prevMonth.format("YYYY-MM")}|Prev (${prevName})]]`

const nextMonth = start.add(1, "month")
const nextName = nextMonth.format(
  nextMonth.year() === start.year() ? "MMM" : "MMM YYYY",
)
const nextMarkdown = `[[${nextMonth.format("YYYY-MM")}|Next (${nextName})]]`

console.info(`${prevMarkdown} | ${nextMarkdown}`)
console.info()

let date = dayjs(start)
while (date.month() === start.month()) {
  if (
    date.day() === 0 && date.date() !== start.date() &&
    date.add(1, "day").month() === start.month()
  ) {
    console.info("\n---\n")
  }

  console.info(`- [[${date.format("YYYY-MM-DD|DD ddd")}]]`)

  date = date.add(1, "day")
}
