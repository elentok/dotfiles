import * as readline from 'readline'

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
