#!/usr/bin/env node

const yaml = require("js-yaml");
const path = require("path");
const fs = require("fs");
const _ = require("underscore");
const Table = require("easy-table");

class Package {
  constructor(name, store, { when, tracking }) {
    this.name = name;
    this.store = store;
    this.when = when;
    this.tracking = tracking;

    if (when == null) {
      console.warn(`WARNING: Package "${name}" is missing "when"`);
    }
  }

  addToTable(table) {
    table.cell("Name", this.name);
    table.cell("Order date", this.getTimeAgo());
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

const command = process.argv[2];
switch (command) {
  case "l":
  case "list":
    listPackages();
    break;
}
