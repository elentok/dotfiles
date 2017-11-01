class Item {
  constructor(titleOrOptions) {
    if (typeof titleOrOptions === "string") {
      this.title = titleOrOptions;
    } else {
      const o = titleOrOptions;
      this.id = o.id;
      this.title = o.title;
      this.img = o.img;
      this.url = o.url;
      this.cost = o.cost;
      this.quantity = o.quantity;
    }
  }

  toJSON() {
    const json = {};
    Object.keys(this).forEach(key => {
      if (this[key] != null) json[key] = this[key];
    });
    return json;
  }
}

module.exports = Item;
