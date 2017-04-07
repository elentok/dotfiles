#!/usr/bin/env node

const yaml = require("js-yaml");
const path = require("path");
const fs = require("fs");
const _ = require("underscore");

class Package {
  constructor(name, store, { when, tracking }) {
    this.name = name;
    this.store = store;
    this.when = when;
    console.log(when);
    this.tracking = tracking;
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

function showStatus() {
  const packages = _.sortBy(loadPackages(), pkg => pkg.when);
  // console.log(packages);

  const titleWidth = _.max(packages.map(pkg => pkg.name.length));
  console.info(`\nExpecting ${packages.length} packages:\n`);

  _.groupBy(packages, pkg => pkg.whenToExpect());
}

const command = process.argv[2];
switch (command) {
  case "s":
  case "status":
    showStatus();
    break;
}
