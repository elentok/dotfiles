const path = require('path')
const _ = require('underscore')
const Order = require('./order')
const OrdersFile = require('./orders-file')
const { getDataDir } = require('./utils')

const ORDERS_FILENAME = path.join(getDataDir(), 'packages.json')
const ARCHIVE_FILENAME = path.join(getDataDir(), 'archive.json')

const ORDERS_FILE = new OrdersFile(ORDERS_FILENAME)
const ARCHIVE_FILE = new OrdersFile(ARCHIVE_FILENAME)

const OrderRepo = {
  all() {
    if (this._all == null) this._load()
    return this._all
  },

  allArchived() {
    return ARCHIVE_FILE.load()
  },

  getTrackable() {
    return this.all().filter(o => o.canTrack())
  },

  reset() {
    this._load()
  },

  _load() {
    this._all = ORDERS_FILE.load()

    this._byId = {}
    this._all.forEach(o => (this._byId[o.id] = o))

    this._sort()
  },

  _sort() {
    this._all = _.sortBy(this._all, order => order.getSortValue())
    this._all.reverse()
  },

  findById(id) {
    if (this._all == null) this._load()
    return this._byId[id]
  },

  add(order, { save = false }) {
    if (!(order instanceof Order)) {
      order = new Order(order)
    }

    order.downloadImages()

    this.all().push(order)
    this._byId[order.id] = order
    if (save) this.save()
    return order
  },

  save() {
    if (this._all == null) return
    this._sort()
    ORDERS_FILE.save(this._all)
  },

  archive(order) {
    this._addToArchiveFile(order)
    this.remove(order)
  },

  _addToArchiveFile(order) {
    const orders = ARCHIVE_FILE.load()

    if (orders.some(o => o.id === order.id)) return

    orders.push(order)
    ARCHIVE_FILE.save(orders)
  },

  remove(order) {
    if (this._all == null) this._load()
    this._all = this._all.filter(o => o.id !== order.id)
    delete this._byId[order.id]
    this.save()
  }
}

module.exports = OrderRepo
