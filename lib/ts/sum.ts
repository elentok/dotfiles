import { readFileSync } from 'fs'
import { runInContext, createContext } from 'vm'

const context = createContext()

export function sum(lines: string[]): number {
  return lines.reduce((sum, line) => {
    return sum + runInContext(line.split(' ')[0], context)
  }, 0)
}

const input = readFileSync(0, 'utf-8')
  .trim()
  .toString()

const totalSum = sum(input.split('\n')).toFixed(3)
console.info(`${input}

  = ${totalSum}`)
