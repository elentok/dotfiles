import * as readline from "readline"

const COLORS = {
  black: "\x1B[30m",
  gray: "\x1B[1;30m",
  red: "\x1B[31m",
  green: "\x1B[32m",
  yellow: "\x1B[33m",
  blue: "\x1B[34m",
  cyan: "\x1B[36m",
}

const RESET = "\x1B[0m"
const CLEAR_LINE = "\r\x1B[K"

const HOURGLASS = "⏳ "

export function printProgress(message: string): void {
  process.stdout.write(`${HOURGLASS} ${COLORS.blue}${message}...${RESET}`)
}

export function clearLine(): void {
  process.stdout.write(CLEAR_LINE)
}

export async function ask(question: string): Promise<string> {
  return new Promise((resolve) => {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
    rl.question(question, (answer: string) => {
      rl.close()
      resolve(answer)
    })
  })
}

export async function confirm(question: string): Promise<boolean> {
  const prettyQuestion = `${COLORS.yellow} ${question} [y/N]? ${RESET}`
  const answer = await ask(prettyQuestion)
  return /^[yY](es)?/.test(answer)
}

type ColorFn = (text: string) => string
function createColorFn(color: string): ColorFn {
  return (text: string) => `${color}${text}${RESET}`
}

export const black = createColorFn(COLORS.black)
export const gray = createColorFn(COLORS.gray)
export const red = createColorFn(COLORS.red)
export const green = createColorFn(COLORS.green)
export const yellow = createColorFn(COLORS.yellow)
export const blue = createColorFn(COLORS.blue)
export const cyan = createColorFn(COLORS.cyan)
