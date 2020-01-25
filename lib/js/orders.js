"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path_1 = require("path");
const os_1 = require("os");
const fs_1 = require("fs");
const underscore_1 = require("underscore");
const ORDERS_FILENAME = path_1.join(os_1.homedir(), 'notes', 'orders.md');
function main() {
    const byMonth = getOrdersByMonth();
    const months = Object.keys(byMonth)
        .sort()
        .reverse();
    months.forEach(month => {
        const orders = byMonth[month];
        const storesStats = getStoresStats(orders);
        console.info(`${month}\t$${sum(orders)}\t${orders.length} orders\t${storesStats}`);
    });
}
function getOrdersByMonth() {
    const allOrders = findOrders(ORDERS_FILENAME);
    return underscore_1.groupBy(allOrders, o => o.month);
}
function getStoresStats(orders) {
    const byStore = underscore_1.groupBy(orders, o => o.store);
    return Object.keys(byStore)
        .map(store => {
        const storeOrders = byStore[store];
        const storeSum = sum(storeOrders);
        return `${store}: $${storeSum}(${storeOrders.length})`;
    })
        .join(', ');
}
function sum(orders) {
    return orders.reduce((total, o) => (o.price != null ? total + o.price : total), 0);
}
var OrderStatus;
(function (OrderStatus) {
    OrderStatus["PAID"] = "PAID";
    OrderStatus["SHIPPED"] = "SHIPPED";
    OrderStatus["IN_MAIL_ROOM"] = "IN_MAIL_ROOM";
    OrderStatus["DELIVERED"] = "DELIVERED";
})(OrderStatus || (OrderStatus = {}));
function findOrders(filename) {
    return fs_1.readFileSync(filename)
        .toString()
        .split('\n')
        .filter(isTableLine)
        .map(parseOrderLine);
}
function isTableLine(line) {
    if (line.charAt(0) !== '|')
        return false;
    if (/^\|\s*(-|Date|\?)/.test(line))
        return false;
    return true;
}
function parseOrderLine(line) {
    const columns = line.split(/\s*\|\s*/);
    return {
        date: new Date(columns[1]),
        month: columns[1].substring(0, 7),
        store: columns[2],
        tracking: columns[3],
        status: parseStatus(columns[4], line),
        price: parsePrice(columns[5]),
        description: columns[6]
    };
}
function parseStatus(rawStatus, rawLine) {
    const statusKey = rawStatus.split(' ')[0];
    if (statusKey in OrderStatus) {
        return statusKey;
    }
    throw new Error(`Invalid order status "${rawStatus}" (line: "${rawLine}")`);
}
function parsePrice(rawPrice) {
    // TODO: support multiple currencies
    if (/^\s*$/.test(rawPrice))
        return;
    return parseFloat(rawPrice.replace('\\$', ''));
}
main();
//# sourceMappingURL=orders.js.map