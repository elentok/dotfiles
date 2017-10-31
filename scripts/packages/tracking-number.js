const IsraelPost = require("./israel-post");
const IParcel = require("../iparcel");

class TrackingNumber {
  constructor(number) {
    this.number = number;
    this.tracker = this._getTracker();
  }

  canTrack() {
    return this.tracker != null;
  }

  track() {
    return this.tracker.track(this.number).then(text => {
      return {
        text,
        number: this.number
      };
    });
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
}

module.exports = TrackingNumber;
