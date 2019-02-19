import { IRepo } from './types'
import { printProgress, clearLine } from '../utils'

export class Remote {
  constructor(private repo: IRepo, public name: string) {
    this.name = name
  }

  fetch() {
    printProgress(`Fetching remote '${this.name}'`)
    this.repo.git(`fetch ${this.name}`)
    clearLine()
  }

  prune() {
    printProgress(`Removing dead branches from '${this.name}'`)
    this.repo.git(`remote prune ${this.name}`)
    clearLine()
  }
}
