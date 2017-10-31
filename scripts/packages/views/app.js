/* globals document fetch */

class TrackingNumber {
  constructor(el) {
    this.el = el;
  }

  track() {
    const resultEl = this.el.querySelector(".o-order-tn__result");

    return fetch(`/track/${this.el.dataset.number}`)
      .then(response => response.json())
      .then(json => {
        resultEl.innerText = json.text;
        return json;
      });
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
      results.forEach(result => {
        if (result.status) {
          const status = result.status.toLowerCase().replace(/ /g, "-");
          this.el.classList.add(`o-order--${status}`);
        }
      });
    });
  }
}

const orders = Array.from(document.querySelectorAll(".o-order")).map(
  el => new Order(el)
);

orders.forEach(o => o.track());
