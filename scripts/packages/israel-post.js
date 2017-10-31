const axios = require("axios");
const htmlToText = require("html-to-text");

const IsraelPost = {
  isSupported(number) {
    return /^[A-Z]{2}\d{9}[A-Z]{2}$/.test(number) || /^\d{13}$/.test(number);
  },

  track(number) {
    const url = this._getUrl(number);
    return axios.get(url).then(response => {
      const text = htmlToText.fromString(response.data.itemcodeinfo, {
        wordwrap: 50,
        tables: true
      });

      let status = "in-transit";
      if (this._isDelivered(text)) {
        status = "delivered";
      } else if (/There is no information/.test(text)) {
        status = "unknown";
      }

      return { text, status };
    });
  },

  _isDelivered(text) {
    return;
    /Delivered to addressee/.test(text) ||
      /postal item was delivered/.test(text);
  },

  _getUrl(number) {
    return (
      "http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON" +
      `?openagent&_=1372171578320&lang=EN&itemcode=${number}`
    );
  }
};

module.exports = IsraelPost;
