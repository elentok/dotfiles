const TrackingNumber = require("./tracking-number");
const Item = require("./item");

class Order {
  constructor(attribs) {
    this.update(attribs);
  }

  update(attribs) {
    this.id = attribs.id;
    this.store = attribs.store;
    this.date = new Date(attribs.date);
    this.items = (attribs.items || []).map(item => new Item(item));
    this.name = attribs.name; // || (this.items || []).join(", ");

    if (attribs.date == null) {
      console.warn(`WARNING: Order "${attribs.name}" is missing "date"`);
    }

    this.tracking = this._createTrackingNumbers(attribs.tracking);
  }

  toJSON() {
    const json = {};
    Object.keys(this).forEach(key => {
      if (this[key] != null) {
        const value = this[key];
        if (Array.isArray(value) && value.length === 0) return;
        json[key] = this[key];
      }
    });

    if (this.items != null && this.items.length > 0) {
      json.items = this.items.map(item => item.toJSON());
    }

    if (this.tracking.length > 0) {
      json.tracking = this.tracking.map(tn => tn.number);
    }
    return json;
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
