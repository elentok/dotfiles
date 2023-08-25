"use strict"
Object.defineProperty(exports, "__esModule", { value: true })
exports.Remote = void 0
const utils_1 = require("../utils")
class Remote {
  constructor(repo, name) {
    this.repo = repo
    this.name = name
    this.name = name
  }
  fetch() {
    ;(0, utils_1.printProgress)(`Fetching remote '${this.name}'`)
    this.repo.git(`fetch ${this.name}`)
    ;(0, utils_1.clearLine)()
  }
  prune() {
    ;(0, utils_1.printProgress)(`Removing dead branches from '${this.name}'`)
    this.repo.git(`remote prune ${this.name}`)
    ;(0, utils_1.clearLine)()
  }
}
exports.Remote = Remote
//# sourceMappingURL=remote.js.map
