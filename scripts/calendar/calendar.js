/* globals div window document */

const DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
  "Saturday"]
const MONTHS = [
  "January", "February", "March", "April", "May", "June", "July", "August",
  "September", "October", "November", "December"]

class DayView {
  constructor(date) {
    this.date = date
    this.el = div(`c-day c-day--${date.getDay()}`)
  }

  render() {
    this.el.appendChild(div("c-day__date c-text--header", this.formatDate()))
    this.el.appendChild(div("c-day__contents c-lines"))
    return this.el
  }

  formatDate() {
    const month = MONTHS[this.date.getMonth()].slice(0, 3)
    const weekday = DAYS[this.date.getDay()]

    return `${weekday}, ${month} ${this.date.getDate()}`
  }
}

class WeekView {
  constructor(sunday) {
    this.sunday = sunday
  }

  render() {
    this.el = div("c-week")

    const day = new Date(this.sunday)
    for (let i=0; i<7; i++) {
      const dayView = new DayView(new Date(day))
      this.el.appendChild(dayView.render())

      day.setDate(day.getDate() + 1)
    }

    return this.el
  }
}

const date = new Date(document.location.search.slice(1))
const weekView = window.weekView = new WeekView(date)
document.querySelector(".c-week-container").appendChild(weekView.render())
