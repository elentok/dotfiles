type TIME_UNIT = "day" | "week" | "month"

export function moveDate(date: Date, value: number, unit: TIME_UNIT): Date {
  const newDate = new Date(date)
  addToDate(newDate, value, unit)
  return newDate
}

export function addToDate(date: Date, value: number, unit: TIME_UNIT): void {
  switch (unit) {
    case "day":
      date.setDate(date.getDate() + value)
      break
    case "week":
      date.setDate(date.getDate() + 7 * value)
      break
    case "month":
      date.setMonth(date.getMonth() + 1)
      break
  }
}

export function isSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getDate() === date2.getDate() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getFullYear() === date2.getFullYear()
  )
}
