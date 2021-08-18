const TrackingNumber = require("./tracking-number");
const Item = require("./item");
const Status = require("./status");
const { leftPad, max } = require("./utils");

class Order {
  constructor(attribs) {
    this.items = [];
    this.tracking = [];
    this.update(attribs);
  }

  update(attribs) {
    if (attribs.id) this.id = attribs.id;
    if (attribs.store) this.store = attribs.store;
    if (attribs.date) this.date = new Date(attribs.date);
    if (attribs.items) {
      this.items = (attribs.items || []).map((item) => new Item(item));
    }
    if (attribs.name) this.name = attribs.name;

    if (attribs.tracking) {
      this.tracking = this._createTrackingNumbers(attribs.tracking);
    }

    this.status = this._parseStatus(attribs);
    this.downloadImages();
  }

  _parseStatus(attribs) {
    if (attribs.status != null) {
      if (attribs.status instanceof Status) return attribs.status;
      return Status.fromName(attribs.status);
    }

    if (attribs.tracking != null && attribs.tracking.length > 0) {
      return Status.fromName("shipped");
    }

    return Status.fromName("unknown");
  }

  toJSON() {
    const json = {};
    Object.keys(this).forEach((key) => {
      if (this[key] != null) {
        const value = this[key];
        if (Array.isArray(value) && value.length === 0) return;
        json[key] = this[key];
      }
    });

    json.status = this.status.toJSON();

    if (this.items != null && this.items.length > 0) {
      json.items = this.items.map((item) => item.toJSON());
    }

    if (this.tracking.length > 0) {
      json.tracking = this.tracking.map((tn) => tn.toJSON());
    }
    return json;
  }

  _createTrackingNumbers(numbers) {
    if (numbers == null) return [];
    if (!Array.isArray(numbers)) return [new TrackingNumber(numbers)];

    return numbers.map((number) => new TrackingNumber(number));
  }

  addToTable(table) {
    table.cell("Name", this.name);
    table.cell("Order date", this.getTimeAgo());
    if (this.tracking != null) {
      table.cell("Tracking#", this.tracking.map((t) => t.number).join(", "));
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
    return Promise.all(this._getTrackable().map((tn) => tn.track())).then((results) => {
      const newStatus = this._identifyNewStatus(results);
      const changed = this.status.name !== newStatus.name;
      if (changed) this.status = newStatus;

      return {
        changed,
        order: this,
        results,
      };
    });
  }

  _identifyNewStatus(trackingResults) {
    const result = max(trackingResults, (r) => r.status.value);
    if (result.status.value >= this.status.value) {
      return result.status;
    }

    return this.status;
  }

  _getTrackable() {
    return this.tracking.filter((t) => t.canTrack());
  }

  addTracking(number) {
    this.tracking.push(new TrackingNumber(number));
  }

  getSortValue() {
    const statusValue = leftPad(this.status.value, 4, "0");
    return [statusValue, this.date.toISOString()].join("-");
  }

  downloadImages() {
    return this.items.forEach((item) => item.downloadImage());
  }
}

module.exports = Order;
