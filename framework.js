const F = {
  COLORS: {
    black: "\033[30m",
    gray: "\033[1;30m",
    red: "\033[31m",
    green: "\033[32m",
    yellow: "\033[33m",
    blue: "\033[34m",
    cyan: "\033[36m",
  },

  RESET: "\033[0m"
}

Object.keys(F.COLORS).forEach((name) => {
  F[name] = (text) => `${F.COLORS[name]}${text}${F.RESET}`
})

module.exports = F
