const { execSync } = require('child_process')

class Disk {
  constructor(attribs) {
    Object.assign(this, attribs)
  }

  toString() {
    return `${this.mount} (${this.freeGB.toFixed(1)}GB free)`
  }

  getFree() {
    return `${this.freeGB.toFixed(1)}GB`
  }

  static parseLine(line) {
    const column = '([^\\s]+)\\s+'
    const re = new RegExp(`^${column}${column}${column}${column}${column}(.*)$`)
    const match = line.match(re)

    return new Disk({
      device: match[1],
      totalKB: parseInt(match[2], 10),
      usedKB: parseInt(match[3], 10),
      freeKB: parseInt(match[4], 10),
      freeGB: parseInt(match[4], 10) / 1024 / 1024,
      capacity: parseInt(match[5], 10) / 100,
      mount: match[6]
    })
  }
}

module.exports = {
  free() {
    return execSync('df')
      .toString()
      .trim()
      .split('\n')
      .slice(1)
      .map(line => Disk.parseLine(line))
  }
}
