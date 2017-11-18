const fs = require('fs')
const yaml = require('js-yaml')
const Order = require('./order')

class OrdersFile {
  constructor(filename) {
    this.filename = filename
  }

  load() {
    if (!fs.existsSync(this.filename)) return []

    return yaml
      .safeLoad(fs.readFileSync(this.filename))
      .map(order => new Order(order))
  }

  save(orders) {
    fs.writeFileSync(this.filename, this._serialize(orders))
  }

  _serialize(orders) {
    const raw = orders.map(item => item.toJSON())
    try {
      return yaml.safeDump(raw, { skipInvalid: true })
    } catch (e) {
      console.error('Error generating YAML:', e)
      console.error(JSON.stringify(raw, null, 2))
      throw e
    }
  }
}

module.exports = OrdersFile
