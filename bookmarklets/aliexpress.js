/* global document window */

function elentokAliExpressExporter() {
  const STATUS_MAPPING = {
    'awaiting shipment': 'processing',
    'awaiting delivery': 'shipped'
  }

  function parseItem(el) {
    const img = el.querySelector('.product-sets .pic img')
    const a = el.querySelector('.product-title a')

    const amountItems = el.querySelectorAll('.product-amount span')

    return {
      img: img.src.replace('50x50', '200x200'),
      title: a.title,
      id: a.getAttribute('productid'),
      url: a.href,
      cost: amountItems[0].innerText.trim(),
      quantity: parseInt(amountItems[1].innerText.replace('X', ''), 10)
    }
  }

  function parseStatus(status) {
    status = status.trim()
    return STATUS_MAPPING[status.toLowerCase()] || status
  }

  function parseOrder(el) {
    const head = el.querySelector('.order-head')

    const orderInfo = head.querySelectorAll('.order-info .info-body')
    const id = orderInfo[0]
    const date = orderInfo[1]

    const sellerName = head.querySelector('.store-info .first-row .info-body')
    const amount = el.querySelector('.order-amount .amount-num')
    const status = el.querySelector('.order-status .f-left')
    const items = Array.from(el.querySelectorAll('.order-body')).map(parseItem)

    return {
      id: id.innerText,
      date: new Date(date.innerText.replace(/\./g, '')),
      store: 'aliexpress',
      seller: sellerName.innerText,
      amount: amount.innerText,
      status: parseStatus(status.innerText.trim()),
      items
    }
  }

  function showPopup(text) {
    const el = document.createElement('div')
    el.style.position = 'fixed'
    el.style.left = '30%'
    el.style.right = '30%'
    el.style.top = '30%'
    el.style.bottom = '30%'

    const button = document.createElement('button')
    button.innerText = 'Close'
    button.style.fontSize = '20px'
    button.style.fontWeight = 'bold'
    button.addEventListener('click', function() {
      el.remove()
    })
    el.appendChild(button)

    const textarea = document.createElement('textarea')
    textarea.style.width = '100%'
    textarea.style.height = '90%'
    textarea.value = text
    el.appendChild(textarea)

    document.body.appendChild(el)

    textarea.select()
    document.execCommand('copy')
  }

  const orders = (window.orders = Array.from(
    document.querySelectorAll('.order-item-wraper')
  ).map(parseOrder))

  const json = JSON.stringify(orders, null, 2)
  showPopup(json)
}

elentokAliExpressExporter()
