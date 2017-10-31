const TrackingNumber = require("./tracking-number");

class Order {
  constructor({ id, name, store, date, tracking, items }) {
    this.id = id;
    this.store = store;
    this.date = date;
    this.items = items;
    this.name = name || (this.items || []).join(", ");

    if (date == null) {
      console.warn(`WARNING: Order "${name}" is missing "date"`);
    }

    this.tracking = this._createTrackingNumbers(tracking);
  }

  _createTrackingNumbers(numbers) {
    if (numbers == null) return [];
    if (!Array.isArray(numbers)) return [new TrackingNumber(numbers)];

    return numbers.map(number => new TrackingNumber(number));
  }

  addToTable(table) {
    table.cell("Name", this.name);
    table.cell("Order date", this.getTimeAgo());
    if (this.tracking != null) {
      table.cell("Tracking#", this.tracking.map(t => t.number).join(", "));
    }
    table.newRow();
  }

  getTimeAgo() {
    const msAgo = new Date() - this.date;
    const daysAgo = Math.floor(msAgo / 1000 / 60 / 60 / 24);

    if (daysAgo === 0) {
      return "today";
    } else if (daysAgo === 1) {
      return "yesterday";
    } else {
      const weeks = Math.floor(daysAgo / 7);
      const days = daysAgo - weeks * 7;

      const values = [];
      if (weeks > 0) {
        values.push(`${weeks}w`);
      }
      if (days > 0) {
        values.push(`${days}d`);
      }

      return values.join(" ") + " ago";
    }
  }

  canTrack() {
    return this._getTrackable().length > 0;
  }

  track() {
    return Promise.all(this._getTrackable().map(t => t.track()));
  }

  _getTrackable() {
    return this.tracking.filter(t => t.canTrack());
  }
}

module.exports = Order;
