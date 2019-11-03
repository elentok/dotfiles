import chalk from 'chalk'
import { justifyLeft, center } from './utils'
import * as moment from 'moment'
import { Moment } from 'moment'

const FRIDAY = 5
const SATURDAY = 6
const TODAY = moment()

function main() {
  const date = process.argv.length > 2 ? moment(process.argv[2]) : moment()
  const month = new Month(date)
  console.info()
  month.prev().print()
  month.print()
  month.next().print()
}

class Month {
  private start: Moment
  private weeks: Week[] = []

  constructor(date: Moment) {
    this.start = date.clone().startOf('month')
    this.buildWeeks()
  }

  public print(): void {
    console.info(chalk.green(center(this.start.format('MMM YYYY'), 27)))
    console.info('Sun Mon Tue Wed Thu Fri Sat')
    this.weeks.forEach(week => console.info(week.pretty()))
    console.info()
  }

  public next(): Month {
    return new Month(this.start.clone().add(1, 'month'))
  }

  public prev(): Month {
    return new Month(this.start.clone().subtract(1, 'month'))
  }

  private buildWeeks(): void {
    let week = new Week()
    const date = this.start.clone().startOf('week')

    while (date < this.start) {
      week.days.push(undefined)
      date.add(1, 'day')
    }

    while (date.month() === this.start.month()) {
      week.days.push(new Day(date))

      if (date.weekday() === SATURDAY) {
        this.weeks.push(week)
        week = new Week()
      }

      date.add(1, 'day')
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
      .map(day => {
        if (day == null) return '   '
        return day.pretty()
      })
      .join(' ')
  }
}

class Day {
  public date: Moment

  constructor(date: Moment) {
    this.date = date.clone()
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
    return this.date.isSame(TODAY, 'day')
  }

  public isWeekend(): boolean {
    return this.date.weekday() >= FRIDAY
  }

  public text(): string {
    return justifyLeft(this.date.date().toString(), 3)
  }
}

main()
