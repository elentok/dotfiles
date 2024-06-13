import chalk from "npm:chalk"
import { DEBUG } from "./helpers.ts"

const orange = chalk.rgb(255, 165, 0)

function prefix(indentLevel: number): string {
  return "  ".repeat(indentLevel)
}

export const print = {
  header(text: string) {
    console.info()
    console.info(chalk.blue(`✨ ${text}`))
    console.info()
  },

  success(text: string, indentLevel = 0) {
    console.info(chalk.green(`${prefix(indentLevel)}✔ ${text}`))
  },

  silentSuccess(text: string, indentLevel = 0) {
    console.info(chalk.gray(`${prefix(indentLevel)}✔ ${text}`))
  },

  warning(text: string, indentLevel = 0) {
    console.info(orange(`${prefix(indentLevel)}⚠ ${text}`))
  },

  error(text: string, indentLevel = 0) {
    console.info(chalk.red(`${prefix(indentLevel)}✘ ${text}`))
  },

  bullet(text: string, indentLevel = 0) {
    console.info(`${prefix(indentLevel)}▶ ${text}`)
  },

  debug(text: string, indentLevel = 0) {
    if (DEBUG) {
      console.info(chalk.gray(`${prefix(indentLevel)}- ${text}`))
    }
  },
}
