/* globals document moment */
/* eslint-disable no-var */

var ui = {
  date: document.querySelector('.date'),
  time: document.querySelector('.time'),
  calendarBody: document.querySelector('.calendar tbody')
}

function initialize() {
  setTimeout(update, 200)
  renderCalendar()
}

function update() {
  ui.time.innerText = moment().format('HH:mm')
  ui.date.innerText = moment().format('dddd, MMMM DD')
}

function renderCalendar() {
  var thisMonth = moment().month()
  var day = moment().startOf('week')
  var today = moment()

  ui.calendarBody.innerHTML = ''

  while (day.month() <= thisMonth) {
    var tr = document.createElement('tr')
    for (var i = 0; i < 7; i++) {
      var td = document.createElement('td')
      if (day.month() === thisMonth) {
        td.innerText = day.date()
        if (day.isSame(today, 'day')) td.className = 'is-today'
      }
      tr.appendChild(td)
      day.add(1, 'day')
    }
    ui.calendarBody.appendChild(tr)
  }
}

initialize()
