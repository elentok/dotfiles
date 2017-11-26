const fs = require('fs')
const Order = require('./order')

class OrdersFile {
  constructor(filename) {
    this.filename = filename
  }

  load() {
    if (!fs.existsSync(this.filename)) return []

    return JSON.parse(fs.readFileSync(this.filename)).map(
      order => new Order(order)
    )
  }

  save(orders) {
    fs.writeFileSync(this.filename, this._serialize(orders))
  }

  _serialize(orders) {
    const raw = orders.map(item => item.toJSON())
    return JSON.stringify(raw, null, 2)
  }
}

module.exports = OrdersFile
