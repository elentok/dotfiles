const IsraelPost = require("./israel-post");
const IParcel = require("../iparcel");

class TrackingNumber {
  constructor(number) {
    if (typeof number === "object") {
      this.number = number.number;
      this.lastUpdate = number.lastUpdate;
    } else {
      this.number = number;
    }

    this.tracker = this._getTracker();
  }

  canTrack() {
    return this.tracker != null;
  }

  track() {
    return this.tracker.track(this.number).then(result => {
      this.lastUpdate = this._buildLastUpdate(result);
      return Object.assign(result, { number: this.number });
    });
  }

  _buildLastUpdate(result) {
    const update = {};
    if (result.text) update.text = result.text;
    if (result.history && result.history.length)
      update.history = result.history;
    return update;
  }

  _getTracker() {
    if (IsraelPost.isSupported(this.number)) {
      return IsraelPost;
    }

    if (IParcel.isSupported(this.number)) {
      return IParcel;
    }

    return null;
  }

  toJSON() {
    if (this.lastUpdate == null) return this.number;

    return {
      number: this.number,
      lastUpdate: this.lastUpdate
    };
  }
}

module.exports = TrackingNumber;
