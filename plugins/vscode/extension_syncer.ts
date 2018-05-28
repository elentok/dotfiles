import { readFileSync, statSync } from 'fs'
import { join, resolve } from 'path'
import { exec } from 'shelljs'

export default class ExtensionSyncer {
  private configPath: string
  private installed: string[]
  private toInstall: string[]
  private installedHash: { [name: string]: boolean }

  constructor(configPath: string) {
    this.toInstall = readFileSync(resolve(__dirname, 'extensions.txt'))
      .toString()
      .split('\n')

    this.installed = exec(`code --list-extensions`, { silent: true })
      .stdout.toString()
      .trim()
      .split('\n')

    this.installedHash = {}
    this.installed.forEach(e => this.installedHash[name])
  }

  public isInstalled(name: string): boolean {
    return this.installedHash[name]
  }

  public run() {
    this.installed
      .filter(name => !this.isInstalled(name))
      .forEach(name => this.install(name))
  }

  public install(name: string): void {
    exec(`code --install-extension ${name}`)
  }
}
