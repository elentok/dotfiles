/* globals document moment */

const ui = {
  date: document.querySelector('.date'),
  time: document.querySelector('.time')
}

function initialize() {
  setTimeout(update, 200)
}

function update() {
  ui.time.innerText = moment().format('HH:mm')
  ui.date.innerText = moment().format('dddd, MMMM DD')
}

initialize()
