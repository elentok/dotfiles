/* globals document fetch */

class TrackingNumber {
  constructor(el) {
    this.el = el;
  }

  track() {
    const resultEl = this.el.querySelector(".o-order-tn__result");

    fetch(`/track/${this.el.dataset.number}`)
      .then(response => response.json())
      .then(json => {
        resultEl.innerText = json.text;
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
    this.trackingNumbers.forEach(number => number.track());
  }
}

const orders = Array.from(document.querySelectorAll(".o-order")).map(
  el => new Order(el)
);

orders.forEach(o => o.track());
