const path = require("path");
const fs = require("fs");
const yaml = require("js-yaml");
const Order = require("./order");
const _ = require("underscore");

const OrderRepo = {
  load() {
    const orders = yaml
      .safeLoad(fs.readFileSync(path.join(process.env.HOME, ".packages")))
      .map(order => new Order(order));

    return _.sortBy(orders, order => order.date);
  }
};

module.exports = OrderRepo;
