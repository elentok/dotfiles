import chalk from 'chalk'
import * as readline from 'readline'

const CLEAR_LINE = '\r\x1B[K'
const HOURGLASS = '⏳ '

export function justifyRight(text: string, width: number, ch: string = ' '): string {
  while (text.length < width) {
    text = `${ch}${text}`
  }

  return text
}

export function justifyLeft(text: string, width: number, ch: string = ' '): string {
  while (text.length < width) {
    text = `${text}${ch}`
  }

  return text
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
