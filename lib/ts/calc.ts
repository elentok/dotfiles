import * as repl from 'repl'
import * as path from 'path'
import chalk from 'chalk'
import { convert, IMoney, getOpenExchangeAppId } from './rates'

const REPL_HISTORY_FILE = path.join(process.env.HOME, '.cache', 'calc')

async function main(): Promise<void> {
  await getOpenExchangeAppId()

  const server = repl.start({
    prompt: '> ',

    eval(cmd: string, _context: any, _filename: string, callback: any) {
      calculate(cmd)
        .catch(err => {
          console.error('Error evaluating: ', err)
          callback(err)
        })
        .then(result => callback(null, result))
    },

    writer(output: string) {
      return '= ' + chalk.green(output) + '\n'
    }
  })
  ;(server as any).setupHistory(REPL_HISTORY_FILE, (err: Error) => {
    if (err != null) console.error('Error writing history', err)
  })
}

async function calculate(expr: string): Promise<string> {
  const c = parseCurrencyExpression(expr)
  if (c != null) {
    const result = await convert(c.from, c.toCurrency)
    return `${result.value.toFixed(2)} ${result.currency}`
  }

  return Promise.resolve(eval(expr))
}

interface ICurrencyExpression {
  from: IMoney
  toCurrency?: string
}

function parseCurrencyExpression(expr: string): ICurrencyExpression {
  const match = expr.match(/([\d.]+)\s*([a-zA-Z$]+)(\s+to\s+([a-zA-Z$]+))?/)

  if (match == null) return null

  // "123.45 nis to usd"
  if (match.length === 5) {
    return {
      from: { value: parseFloat(match[1]), currency: match[2] },
      toCurrency: match[4]
    }
  }

  // "123.45 nis"
  if (match.length === 3) {
    return {
      from: { value: parseFloat(match[1]), currency: match[2] }
    }
  }

  return null
}

main()
