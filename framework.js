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
    process.stdout.write(
      `${this.HOURGLASS} ${this.COLORS.blue}${message}...${this.RESET}`
    )
  },

  clearLine() {
    process.stdout.write(this.CLEAR_LINE)
  }
}

Object.keys(F.COLORS).forEach(name => {
  F[name] = text => `${F.COLORS[name]}${text}${F.RESET}`
})

module.exports = F
