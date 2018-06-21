const F = require('../../framework.js')

class Remote {
  constructor(repo, name) {
    this._repo = repo
    this.name = name
  }

  fetch() {
    F.printProgress(`Fetching remote '${this.name}'`)
    this._repo.git(`fetch ${this.name}`)
    F.clearLine()
  }

  prune() {
    F.printProgress(`Removing dead branches from '${this.name}'`)
    this._repo.git(`remote prune ${this.name}`)
    F.clearLine()
  }
}

module.exports = Remote
