const OrderRepo = require('./order-repo')
const { paste } = require('copy-paste')

const STATUSES_TO_IGNORE = ['closed', 'finished']

const Importer = {
  importFromClipboard() {
    const ordersToImport = JSON.parse(paste())
    ordersToImport.forEach(orderToImport => {
      const order = OrderRepo.findById(orderToImport.id)
      if (order != null) {
        console.info(`[IMPORT] Updating ${orderToImport.id}`)
        order.update(orderToImport)
      } else {
        if (
          STATUSES_TO_IGNORE.indexOf(orderToImport.status.toLowerCase()) === -1
        ) {
          console.info(`[IMPORT] Adding ${orderToImport.id}`)
          OrderRepo.add(orderToImport, { save: false })
        }
      }
    })
    OrderRepo.save()
  }
}

module.exports = Importer
