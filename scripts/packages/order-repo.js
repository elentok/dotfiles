const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");
const Order = require("./order");
const _ = require("underscore");
const { getDataDir } = require("./utils");

const ORDERS_FILENAME = path.join(getDataDir(), "packages.yml");

const OrderRepo = {
  all() {
    if (this._all == null) this._load();
    return this._all;
  },

  getTrackable() {
    return this.all().filter(o => o.canTrack());
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

    order.downloadImages();

    this.all().push(order);
    this._byId[order.id] = order;
    if (save) this.save();
    return order;
  },

  save() {
    if (this._all == null) return;
    fs.writeFileSync(ORDERS_FILENAME, this._dump());
  },

  _dump() {
    this._sort();
    const raw = this._all.map(o => o.toJSON());
    try {
      return yaml.safeDump(raw, { skipInvalid: true });
    } catch (e) {
      console.error("Error generating YAML:", e);
      console.error(JSON.stringify(raw, null, 2));
      throw e;
    }
  }
};

module.exports = OrderRepo;
