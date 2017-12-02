/* global document */

function elentokAmazonExporter() {
  function tag(name, style) {
    const el = document.createElement(name)
    Object.assign(el.style, style)
    return el
  }

  function showPopup(text) {
    const el = tag('div', {
      position: 'fixed',
      left: '30%',
      right: '30%',
      top: '30%',
      bottom: '30%',
      zIndex: 1000,
      backgroundColor: 'white'
    })

    const button = tag('button', { fontSize: '20px', fontWeight: 'bold' })
    button.innerText = 'Close'
    button.addEventListener('click', function() {
      el.remove()
    })
    el.appendChild(button)

    const textarea = tag('textarea', {
      width: '100%',
      height: '90%',
      backgroundColor: 'white'
    })
    textarea.value = text
    el.appendChild(textarea)

    document.body.appendChild(el)

    textarea.select()
    document.execCommand('copy')
  }

  function _parseOrderFields(el) {
    const cols = Array.from(el.querySelectorAll('.order-info .a-column'))

    const keys = cols.map(col => col.querySelector('.label').innerText.trim())
    const values = cols.map(col => col.querySelector('.value').innerText.trim())

    const fields = {}
    keys.forEach((key, index) => (fields[key] = values[index]))
    return fields
  }

  function _parseItem(el) {
    const a = el.querySelector('.a-col-right .a-link-normal')

    return {
      img: el.querySelector('img').src,
      title: a.innerText.trim(),
      url: a.href,
      id: a.href.match(/amazon.com\/gp\/product\/([^/]+)/)[1]
    }
  }

  function _parseItems(el) {
    return Array.from(el.querySelectorAll('.a-fixed-left-grid')).map(_parseItem)
  }

  function parseOrder(el) {
    const fields = _parseOrderFields(el)

    return {
      id: el.querySelector('.order-info .actions .value').innerText,
      date: new Date(fields['ORDER PLACED']),
      amount: fields.TOTAL,
      store: 'amazon',
      items: _parseItems(el)
    }
  }

  const orders = Array.from(document.querySelectorAll('.order')).map(parseOrder)
  const json = JSON.stringify(orders, null, 2)
  showPopup(json)
}

elentokAmazonExporter()
