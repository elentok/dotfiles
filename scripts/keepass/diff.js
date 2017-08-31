const kdbxweb = require("kdbxweb");

class Diff {
  constructor() {
    this.db1missingGroups = [];
    this.db2missingGroups = [];
    this.db1missingEntries = [];
    this.db2missingEntries = [];
    this.changedEntries = [];
  }

  summary() {
    console.info("DB1 missing groups:");
    console.info(this.db1missingGroups);

    console.info("\nDB2 missing groups:");
    console.info(this.db2missingGroups);

    console.info("\nDB1 missing entries:");
    console.info(this.db1missingEntries);

    console.info("\nDB2 missing entries:");
    console.info(this.db2missingEntries);

    console.info("\nchanged entries:");
    this.changedEntries.forEach(({ entry1, diff }) => {
      console.info(`* ${entry1.fields.Title}`);
      Object.keys(diff).forEach(key => {
        console.info(`  * ${key}: ${diff[key]}`);
      });
    });
  }

  compare(db1, db2) {
    this._compareGroups(
      db1.getKdbx().getDefaultGroup(),
      db2.getKdbx().getDefaultGroup()
    );
  }

  _compareGroups(group1, group2) {
    this._compareSubgroups(group1, group2);
    this._compareEntries(group1, group2);
  }

  _compareSubgroups(group1, group2) {
    const sg2byUuid = {};
    group2.groups.forEach(sg2 => (sg2byUuid[sg2.uuid] = sg2));

    group1.groups.forEach(sg1 => {
      const sg2 = sg2byUuid[sg1.uuid];
      delete sg2byUuid[sg1.uuid];

      if (sg2 == null) {
        this.db1missingGroups.push(sg2);
      } else {
        this._compareGroups(sg1, sg2);
      }
    });

    Object.values(sg2byUuid).forEach(sg2 => this.db2missingGroups.push(sg2));
  }

  _compareEntries(group1, group2) {
    const entry2byUuid = {};
    group2.entries.forEach(entry2 => (entry2byUuid[entry2.uuid] = entry2));

    group1.entries.forEach(entry1 => {
      const entry2 = entry2byUuid[entry1.uuid];
      delete entry2byUuid[entry1.uuid];

      if (entry2 == null) {
        this.db2missingEntries.push(entry1);
      } else {
        this._compareSameEntry(entry1, entry2);
      }
    });

    Object.values(entry2byUuid).forEach(entry2 =>
      this.db1missingEntries.push(entry2)
    );
  }

  _compareSameEntry(entry1, entry2) {
    const entry2fields = Object.assign({}, entry2.fields);

    const diff = {};

    Object.keys(entry1.fields).forEach(key => {
      const entry1value = entry1.fields[key];
      const entry2value = entry2fields[key];
      delete entry2fields[key];

      if (!this._sameValue(entry1value, entry2value)) {
        diff[key] = [entry1value, entry2value];
      }
    });

    if (Object.keys(diff).length > 0) {
      this.changedEntries.push({ entry1, entry2, diff });
    }
  }

  _sameValue(value1, value2) {
    if (
      value1 instanceof kdbxweb.ProtectedValue &&
      value2 instanceof kdbxweb.ProtectedValue
    ) {
      return value1.getText() === value2.getText();
    }

    return value1 === value2;
  }
}

module.exports = Diff;
