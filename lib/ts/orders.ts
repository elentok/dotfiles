import { join } from 'path'
import { homedir } from 'os'
import { readFileSync } from 'fs'
import { groupBy } from 'underscore'

const ORDERS_FILENAME = join(homedir(), 'notes', 'orders.md')

function main(): void {
  const byMonth = getOrdersByMonth()
  const months = Object.keys(byMonth)
    .sort()
    .reverse()

  months.forEach(month => {
    const orders = byMonth[month]
    const storesStats = getStoresStats(orders)

    console.info(`${month}\t$${sum(orders)}\t${orders.length} orders\t${storesStats}`)
  })
}

function getOrdersByMonth(): Record<string, IOrder[]> {
  const allOrders = findOrders(ORDERS_FILENAME)
  return groupBy(allOrders, o => o.month)
}

function getStoresStats(orders: IOrder[]): string {
  const byStore = groupBy(orders, o => o.store)
  return Object.keys(byStore)
    .map(store => {
      const storeOrders = byStore[store]
      const storeSum = sum(storeOrders)
      return `${store}: $${storeSum}(${storeOrders.length})`
    })
    .join(', ')
}

function sum(orders: IOrder[]): number {
  return orders.reduce((total, o) => (o.price != null ? total + o.price : total), 0)
}

enum OrderStatus {
  PAID = 'PAID',
  SHIPPED = 'SHIPPED',
  IN_MAIL_ROOM = 'IN_MAIL_ROOM',
  DELIVERED = 'DELIVERED'
}

interface IOrder {
  date: Date
  month: string
  store: string
  tracking: string
  status: OrderStatus
  price?: number
  description: string
}

function findOrders(filename: string): IOrder[] {
  return readFileSync(filename)
    .toString()
    .split('\n')
    .filter(isTableLine)
    .map(parseOrderLine)
}

function isTableLine(line: string): boolean {
  if (line.charAt(0) !== '|') return false
  if (/^\|\s*(-|Date|\?)/.test(line)) return false

  return true
}

function parseOrderLine(line: string): IOrder {
  const columns = line.split(/\s*\|\s*/)
  return {
    date: new Date(columns[1]),
    month: columns[1].substring(0, 7),
    store: columns[2],
    tracking: columns[3],
    status: parseStatus(columns[4], line),
    price: parsePrice(columns[5]),
    description: columns[6]
  }
}

function parseStatus(rawStatus: string, rawLine: string): OrderStatus {
  const statusKey = rawStatus.split(' ')[0]

  if (statusKey in OrderStatus) {
    return statusKey as OrderStatus
  }

  throw new Error(`Invalid order status "${rawStatus}" (line: "${rawLine}")`)
}

function parsePrice(rawPrice: string): number | undefined {
  // TODO: support multiple currencies
  if (/^\s*$/.test(rawPrice)) return

  return parseFloat(rawPrice.replace('\\$', ''))
}

main()
