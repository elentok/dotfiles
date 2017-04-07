#!/usr/bin/env node

const yaml = require("js-yaml");
const path = require("path");
const fs = require("fs");
const _ = require("underscore");
const Table = require("easy-table");
const axios = require("axios");
const htmlToText = require("html-to-text");
const colors = require("colors");
const CLEAR_LINE = "\r\x1B[K";

const IsraelPost = {
  isSupported(number) {
    return /^[A-Z]{2}\d{9}[A-Z]{2}$/.test(number) || /^\d{13}$/.test(number);
  },

  track(number) {
    const url = this._getUrl(number);
    return axios.get(url).then(response => {
      const text = htmlToText.fromString(response.data.itemcodeinfo, {
        wordwrap: 100,
        tables: true
      });
      return text;
    });
  },

  _getUrl(number) {
    return "http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON" +
      `?openagent&_=1372171578320&lang=EN&itemcode=${number}`;
  }
};

class Package {
  constructor(name, store, { when, tracking }) {
    this.name = name;
    this.store = store;
    this.when = when;
    this.tracking = tracking;

    if (when == null) {
      console.warn(`WARNING: Package "${name}" is missing "when"`);
    }

    if (tracking != null) {
      if (IsraelPost.isSupported(tracking)) {
        this.tracker = IsraelPost;
      }
    }
  }

  addToTable(table) {
    table.cell("Name", this.name);
    table.cell("Order date", this.getTimeAgo());
    if (this.tracking != null) {
      table.cell("Tracking#", this.tracking);
    }
    table.newRow();
  }

  getTimeAgo() {
    const msAgo = new Date() - this.when;
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
}

function loadPackages() {
  const packagesByStore = yaml.safeLoad(
    fs.readFileSync(path.join(process.env.HOME, ".packages"))
  );

  const packages = [];

  Object.keys(packagesByStore).forEach(store => {
    const packagesByName = packagesByStore[store];
    Object.keys(packagesByName).forEach(name => {
      packages.push(new Package(name, store, packagesByName[name]));
    });
  });

  return packages;
}

function listPackages() {
  const packages = _.sortBy(loadPackages(), pkg => pkg.when);
  const table = new Table();
  packages.forEach(pkg => pkg.addToTable(table));

  console.info(`\nExpecting ${packages.length} packages:\n`);
  console.info(table.toString());
}

class Tracker {
  track(packages) {
    const trackable = packages.filter(pkg => pkg.tracker != null);
    this.remaining = trackable.length;
    this._printStatus();

    return Promise.all(trackable.map(pkg => this._trackSingle(pkg)));
  }

  _printStatus() {
    let msg;
    if (this.remaining > 0) {
      msg = colors.yellow(`Tracking... ${this.remaining} packages left...`);
    } else {
      msg = colors.green("\n=============\nDone :)\n=============\n");
    }
    process.stderr.write(`${CLEAR_LINE}${msg}`);
  }

  _trackSingle(pkg) {
    return pkg.tracker.track(pkg.tracking).then(text => {
      process.stderr.write(CLEAR_LINE);
      console.info(`Package ${pkg.name} (${pkg.tracking}):`);

      if (this._isDelivered(text)) {
        text = colors.green(text);
      } else if (!/There is no information/.test(text)) {
        text = colors.blue(text);
      } else {
        text = colors.gray(text);
      }

      console.info(text);
      console.info();

      this.remaining--;
      this._printStatus();
    });
  }

  _isDelivered(text) {
    return /Delivered to addressee/.test(text) ||
      /postal item was delivered/.test(text);
  }
}

const command = process.argv[2];
switch (command) {
  case "l":
  case "list":
    listPackages();
    break;

  case "t":
  case "track":
    new Tracker().track(loadPackages());
    break;
}
