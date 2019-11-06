/* global document */

const DOLLAR = 3.78
const arrayify = items => [].slice.call(items)
const parsePrice = text => parseFloat(text.replace('$', ''))

function findTotal() {
  return parsePrice(document.querySelector('.grand-total-price').innerText)
}

function findPrice(regex) {
  const tds = arrayify(document.querySelectorAll('#subtotals-marketplace-table td'))

  const index = tds.findIndex(td => td.innerText.match(regex))
  return parsePrice(tds[index + 1].innerText)
}

class Item {
  constructor(el) {
    this.el = el
    this.title = el.querySelector('.asin-title').innerText
    this.price = parsePrice(el.querySelector('.a-color-price').innerText)
    this.quantity = parseInt(el.querySelector('.quantity-display').innerText, 10)

    this.totalPrice = this.price * this.quantity
    this.infoContainer = this.el.querySelector('.a-column:last-child')
  }

  setShippingPrice(value) {
    this.shippingPrice = value
    this.withShipping = this.totalPrice + this.shippingPrice

    this.addPrice('With Shipping', this.withShipping, {
      color: 'green',
      'font-size': '18px'
    })
    this.addPrice('Shipping Only', value, { 'font-size': '14px' })
  }

  addPrice(name, priceInDollars, attribs) {
    this.infoContainer.appendChild(createPriceEl(name, priceInDollars, attribs))
  }
}

function createPriceEl(title, priceInDollars, style = {}) {
  const div = document.createElement('div')
  Object.assign(div.style, style)

  div.innerText =
    `${title}: $${priceInDollars.toFixed(2)}` + ` (ILS ${(priceInDollars * DOLLAR).toFixed(2)})`

  return div
}

function findItems() {
  return arrayify(document.querySelectorAll('.shipping-group > .a-row > .a-column > .a-row'))
    .filter(el => el.querySelector('.asin-title'))
    .map(el => new Item(el))
}

function calculateWithShipping() {
  const total = findTotal()
  const itemsPrice = findPrice(/Items/)
  const shippingPrice = findPrice(/Shipping/)

  console.info(`Total price: ${total}`)
  console.info(`Items price: ${itemsPrice}`)
  console.info(`Shipping price: ${shippingPrice}`)

  const items = findItems()

  items.forEach(item => {
    const percentage = item.totalPrice / itemsPrice
    item.setShippingPrice(shippingPrice * percentage)
    console.info(`Shipping price for ${item.title}: ${item.shippingPrice}`)
  })
}

calculateWithShipping()
