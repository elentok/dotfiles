const axios = require("axios");
const htmlToText = require("html-to-text");
const $ = require("cheerio");
const Status = require("./status");

const IsraelPost = {
  isSupported(number) {
    return /^[A-Z]{2}\d{9}[A-Z]{2}$/.test(number) || /^\d{13}$/.test(number);
  },

  track(number) {
    const url = this._getUrl(number);
    return axios.get(url).then((response) => {
      const text = htmlToText.fromString(response.data.itemcodeinfo, {
        wordwrap: 50,
        tables: true,
      });

      let status = Status.fromName("in-transit");
      if (this._isDelivered(text)) {
        status = Status.fromName("delivered");
      } else if (/There is no information/.test(text)) {
        status = Status.fromName("unknown");
      }

      return {
        text,
        status,
        history: this._parseHtml(response.data.itemcodeinfo),
      };
    });
  },

  _parseHtml(html) {
    const $html = $.load(html);

    return $html("tr")
      .toArray()
      .map((item) => {
        const $item = $(item);
        const tds = $item
          .find("td")
          .toArray()
          .map((td) => $(td).html());
        const postalUnit = tds[1];
        const city = tds[2];
        const description = tds[3];
        return {
          date: tds[0],
          postalUnit,
          city,
          description,
          text: `${description} (${city}, ${postalUnit})`,
        };
      });
  },

  _isDelivered(text) {
    return /Delivered to addressee/.test(text) || /postal item was delivered/.test(text);
  },

  _getUrl(number) {
    return (
      "http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON" +
      `?openagent&_=1372171578320&lang=EN&itemcode=${number}`
    );
  },
};

module.exports = IsraelPost;
