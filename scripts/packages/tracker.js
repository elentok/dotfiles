const chalk = require('chalk')
const CLEAR_LINE = '\r\x1B[K'

class Tracker {
  track(orders) {
    const trackable = orders.filter(order => order.canTrack())
    this.remaining = trackable.length
    this._printStatus()

    return Promise.all(trackable.map(order => this._trackOrder(order)))
  }

  _printStatus() {
    let msg
    if (this.remaining > 0) {
      msg = chalk.yellow(`Tracking... ${this.remaining} orders left...`)
    } else {
      msg = chalk.green('\n=============\nDone :)\n=============\n')
    }
    process.stderr.write(`${CLEAR_LINE}${msg}`)
  }

  _trackOrder(order) {
    return order.track().then(results => {
      process.stderr.write(CLEAR_LINE)
      console.info(`Order ${order.name}:`)

      results.forEach(result => this._printTrackingResult(result))

      this.remaining--
      this._printStatus()
    })
  }

  _printTrackingResult(result) {
    console.info(`  Tracking #${result.number}:`)

    let text = result.text
    text = this._indentText(text)
    if (this._isDelivered(text)) {
      text = chalk.green(text)
    } else if (!/There is no information/.test(text)) {
      text = chalk.blue(text)
    } else {
      text = chalk.gray(text)
    }

    console.info(text)
    console.info()
  }

  _indentText(text) {
    if (text == null || text.length === 0) return ''
    return text
      .toString()
      .split('\n')
      .map(line => line.replace(/^/, '  '))
      .join('\n')
  }

  _isDelivered(text) {
    return /Delivered to addressee/.test(text) || /postal item was delivered/.test(text)
  }
}

module.exports = Tracker
