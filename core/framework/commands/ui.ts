import chalk from "npm:chalk"

const orange = chalk.rgb(255, 165, 0)

export const print = {
  header(text: string) {
    console.info()
    console.info(chalk.blue(`✨ ${text}`))
    console.info()
  },

  success(text: string) {
    console.info(chalk.green(`✔ ${text}`))
  },

  silentSuccess(text: string) {
    console.info(chalk.gray(`✔ ${text}`))
  },

  warning(text: string) {
    console.info(orange(`⚠ ${text}`))
  },

  error(text: string) {
    console.info(chalk.red(`✘ ${text}`))
  },

  bullet(text: string) {
    console.info(`▶ ${text}`)
  },
}
