/* globals document fetch */

function dom(tagName, className, contents) {
  const el = document.createElement(tagName);
  if (className != null) {
    el.className = className;
  }
  if (contents != null) {
    el.innerText = contents;
  }

  return el;
}

class TrackingNumber {
  constructor(el) {
    this.el = el;
  }

  track() {
    const resultEl = this.el.querySelector(".o-order-tn__result");

    return fetch(`/track/${this.el.dataset.number}`)
      .then(response => response.json())
      .then(json => {
        if (json.history != null) {
          resultEl.appendChild(this._renderHistoryTable(json.history));
        } else if (json.text != null) {
          resultEl.innerText = json.text;
        }
        return json;
      });
  }

  _renderHistoryTable(history) {
    const table = dom("table");

    history.forEach(item => {
      const tr = dom("tr");

      const date = dom("td", null, item.date);
      const text = dom("td", null, item.text);
      tr.appendChild(date);
      tr.appendChild(text);

      table.appendChild(tr);
    });

    return table;
  }
}

class Order {
  constructor(el) {
    this.el = el;
    this.trackingNumbers = Array.from(el.querySelectorAll(".o-order-tn")).map(
      numberEl => new TrackingNumber(numberEl)
    );
  }

  track() {
    Promise.all(
      this.trackingNumbers.map(number => number.track())
    ).then(results => {
      let finalStatus = null;

      results.forEach(result => {
        if (result.status) {
          if (result.status !== "unknown") finalStatus = result.status;
          const status = result.status.toLowerCase().replace(/ /g, "-");
          this.el.classList.add(`o-order--${status}`);
        }
      });

      if (finalStatus != null) {
        this.el.parentElement.insertBefore(
          this.el,
          this.el.parentElement.childNodes[0]
        );
      }
    });
  }
}

const orders = Array.from(document.querySelectorAll(".o-order")).map(
  el => new Order(el)
);

orders.forEach(o => o.track());
