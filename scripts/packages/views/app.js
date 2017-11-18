/* globals document fetch window prompt */

function dom(tagName, className, contents) {
  const el = document.createElement(tagName)
  if (className != null) {
    el.className = className
  }
  if (contents != null) {
    el.innerText = contents
  }

  return el
}

class TrackingNumber {
  constructor(el) {
    this.el = el
  }

  track() {
    this.el.classList.add('o-order--refreshing')

    const resultEl = this.el.querySelector('.o-order-tn__result')

    return fetch(`/track/${this.el.dataset.number}`)
      .then(response => response.json())
      .then(json => {
        if (json.history != null) {
          resultEl.appendChild(this._renderHistoryTable(json.history))
        } else if (json.text != null) {
          resultEl.innerText = json.text
        }
        this.el.classList.remove('o-order--refreshing')
        return json
      })
      .catch(err => {
        console.error(`Error tracking ${this.el.dataset.number}`, err)
        this.el.classList.remove('o-order--refreshing')
      })
  }

  _renderHistoryTable(history) {
    const table = dom('table')

    history.forEach(item => {
      const tr = dom('tr')

      const date = dom('td', null, item.date)
      const text = dom('td', null, item.text)
      tr.appendChild(date)
      tr.appendChild(text)

      table.appendChild(tr)
    })

    return table
  }
}

class Order {
  constructor(el) {
    this.el = el

    const getButton = name => this.el.querySelector(`.o-toolbar-item--${name}`)

    function onClick(name, callback) {
      getButton(name).addEventListener('click', event => {
        event.preventDefault()
        callback()
      })
    }

    onClick('archive', () => this.archive())
    onClick('add-tracking', () => this.addTracking())

    this.trackingNumbers = Array.from(el.querySelectorAll('.o-order-tn')).map(
      numberEl => new TrackingNumber(numberEl)
    )
  }

  archive() {
    fetch(`/orders/${this.el.dataset.id}/archive`).then(() => this.el.remove())
  }

  addTracking() {
    const number = prompt('Enter tracking number:')
    fetch(`/orders/${this.el.dataset.id}/addTracking/${number}`)
  }

  track() {
    Promise.all(
      this.trackingNumbers.map(number => number.track())
    ).then(results => {
      let finalStatus = null

      results.forEach(result => {
        if (result.status) {
          if (result.status !== 'unknown') finalStatus = result.status
          const status = result.status.toLowerCase().replace(/ /g, '-')
          this.el.classList.add(`o-order--${status}`)
        }
      })

      if (finalStatus != null) {
        this.el.parentElement.insertBefore(
          this.el,
          this.el.parentElement.childNodes[0]
        )
      }
    })
  }
}

class App {
  constructor() {
    this.ui = {
      refreshButton: document.querySelector('.o-toolbar-btn--refresh'),
      message: document.querySelector('.o-toolbar__message')
    }

    this.ui.refreshButton.addEventListener('click', e => {
      e.preventDefault()
      this.track()
    })

    this.orders = Array.from(document.querySelectorAll('.o-order')).map(
      el => new Order(el)
    )
  }

  track() {
    this.ui.message.innerText = 'Tracking...'

    fetch('/track-all')
      .then(result => result.json())
      .then(json => {
        if (json && json.length > 0) {
          window.location.href = window.location.href
        } else {
          this.ui.message.innerText = 'Done tracking, no updates'
        }
      })
  }
}

window.app = new App()
