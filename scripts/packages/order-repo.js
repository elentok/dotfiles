const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");
const Order = require("./order");
const _ = require("underscore");

const ORDERS_FILENAME = path.join(process.env.HOME, ".packages");

const OrderRepo = {
  all() {
    if (this._all == null) this._load();
    return this._all;
  },

  reset() {
    this._load();
  },

  _load() {
    this._all = yaml
      .safeLoad(fs.readFileSync(ORDERS_FILENAME))
      .map(order => new Order(order));

    this._byId = {};
    this._all.forEach(o => (this._byId[o.id] = o));

    this._sort();
  },

  _sort() {
    this._all = _.sortBy(this._all, order => order.getSortValue());
    this._all.reverse();
  },

  findById(id) {
    if (this._all == null) this._load();
    return this._byId[id];
  },

  add(order, { save = false }) {
    if (!(order instanceof Order)) {
      order = new Order(order);
    }

    this.all().push(order);
    this._byId[order.id] = order;
    if (save) this.save();
  },

  save() {
    if (this._all == null) return;
    fs.writeFileSync(ORDERS_FILENAME, this._dump());
  },

  _dump() {
    this._sort();
    const raw = this._all.map(o => o.toJSON());
    try {
      return yaml.safeDump(raw);
    } catch (e) {
      console.error("Error generating YAML:", e);
      throw e;
    }
  }
};

module.exports = OrderRepo;
