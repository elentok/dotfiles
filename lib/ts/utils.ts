import chalk from 'chalk'
import * as readline from 'readline'

const CLEAR_LINE = '\r\x1B[K'
const HOURGLASS = '⏳ '

export function justifyRight(text: string, width: number, ch: string = ' '): string {
  if (text.length >= width) return text

  const leftPad = width - text.length
  return `${ch.repeat(leftPad)}${text}`
}

export function justifyLeft(text: string, width: number, ch: string = ' '): string {
  if (text.length >= width) return text

  const rightPad = width - text.length
  return `${text}${ch.repeat(rightPad)}`
}

export function center(text: string, width: number, ch: string = ' '): string {
  if (text.length >= width) return text

  const leftPad = Math.floor((width - text.length) / 2)
  const rightPad = width - text.length - leftPad

  return `${ch.repeat(leftPad)}${text}${ch.repeat(rightPad)}`
}

export async function ask(question: string): Promise<string> {
  return new Promise(resolve => {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
    rl.question(question, answer => {
      rl.close()
      resolve(answer)
    })
  })
}

export async function confirm(question: string): Promise<boolean> {
  const prettyQuestion = chalk.yellow(`${question} [y/N]? `)
  const answer = await ask(prettyQuestion)
  return /^[yY](es)?/.test(answer)
}

export function clearLine(): void {
  process.stdout.write(CLEAR_LINE)
}

export function printProgress(message: string): void {
  process.stdout.write(`${HOURGLASS} ${chalk.blue(message)}...`)
}

export function notUndefined<T>(x: T | undefined): x is T {
  return x !== undefined
}

export function stringifyDateOnly(date: Date): string {
  const month = justifyLeft(date.getMonth().toString(), 2, '0')
  const day = justifyLeft(date.getDate().toString(), 2, '0')
  return `${date.getFullYear()}-${month}-${day}`
}
