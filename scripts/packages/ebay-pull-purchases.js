function parseOrder(_index, row) {
  const $row = $(row)

  return {
    date: parseDate($row.find('.row-date').text()),
    cost: $row.find('.purchase-info .cost-label').text(),
    estimated: $row.find('.delivery-date:first strong').text(),
    items: $row
      .find('.item-spec-r')
      .map(parseItem)
      .toArray(),
    tracking: $row
      .find('.tracking-label:first a')
      .text()
      .replace('Tracking number', '')
  }
}

function parseItem(_index, item) {
  const $item = $(item)
  return {
    title: $item.find('.item-title').text(),
    id: $item
      .find('.display-item-id')
      .text()
      .replace(/\s*[\(\)]\s*/g, '')
  }
}

function parseDate(date) {
  return new Date(date).toISOString().split('T')[0]
}

const orders = $('.order-r')
  .map(parseOrder)
  .toArray()

const packages = []
orders.forEach(function(order) {
  order.items.forEach(function(item) {
    const args = [JSON.stringify(item.title)]
    ;['date', 'id', 'estimated', 'tracking', 'estimated'].forEach(function(field) {
      if (order[field].length > 0) {
        args.push(field + ': ' + JSON.stringify(order[field]))
      }
    })

    packages.push('pkg ' + args.join(', '))
  })
})
copy(packages.join('\n'))
