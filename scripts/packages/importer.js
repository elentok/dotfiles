const OrderRepo = require("./order-repo");
const { paste } = require("copy-paste-win32fix");

const STATUSES_TO_IGNORE = ["closed", "finished"];

const Importer = {
  importFromClipboard() {
    const ordersToImport = JSON.parse(paste());
    const isArchived = this.getArchivedIds();

    ordersToImport.forEach((orderToImport) => {
      if (isArchived[orderToImport.id]) {
        console.info(`[IMPORT] Ignoring archived order ${orderToImport.id}`);
        return;
      }

      const order = OrderRepo.findById(orderToImport.id);
      if (order != null) {
        console.info(`[IMPORT] Updating ${orderToImport.id}`);
        order.update(orderToImport);
      } else {
        const status = (orderToImport.status || "").toLowerCase();
        if (STATUSES_TO_IGNORE.indexOf(status) === -1) {
          console.info(`[IMPORT] Adding ${orderToImport.id}`);
          OrderRepo.add(orderToImport, { save: false });
        }
      }
    });
    OrderRepo.save();
  },

  getArchivedIds() {
    const ids = {};
    OrderRepo.allArchived().forEach((o) => (ids[o.id] = true));
    return ids;
  },
};

module.exports = Importer;
