const readline = require('readline')

const F = {
  COLORS: {
    black: '\x1B[30m',
    gray: '\x1B[1;30m',
    red: '\x1B[31m',
    green: '\x1B[32m',
    yellow: '\x1B[33m',
    blue: '\x1B[34m',
    cyan: '\x1B[36m'
  },

  RESET: '\x1B[0m',
  CLEAR_LINE: '\r\x1B[K',

  HOURGLASS: '⏳ ',

  padRight(string, length) {
    while (string.length < length) {
      string += ' '
    }
    return string
  },

  printProgress(message) {
    process.stdout.write(`${this.HOURGLASS} ${this.COLORS.blue}${message}...${this.RESET}`)
  },

  clearLine() {
    process.stdout.write(this.CLEAR_LINE)
  },

  ask(question) {
    return new Promise(resolve => {
      const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
      rl.question(question, answer => {
        rl.close()
        resolve(answer)
      })
    })
  },

  confirm(question) {
    const prettyQuestion = `${F.COLORS.yellow} ${question} [y/N]? ${F.RESET}`
    return F.ask(prettyQuestion).then(answer => /^[yY](es)?/.test(answer))
  }
}

Object.keys(F.COLORS).forEach(name => {
  F[name] = text => `${F.COLORS[name]}${text}${F.RESET}`
})

module.exports = F
