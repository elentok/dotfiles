import { readFileSync, writeFileSync } from 'fs'
import { resolve } from 'path'
import { exec } from 'shelljs'

export default class Extensions {
  public static fromTextFile(filename: string): Extensions {
    return new Extensions(
      readFileSync(filename)
        .toString()
        .split('\n')
    )
  }

  public static fromVSCode(): Extensions {
    return new Extensions(
      exec(`code --list-extensions`, { silent: true })
        .stdout.toString()
        .trim()
        .split('\n')
        .filter(name => name.length > 0)
    )
  }

  public static install(name: string): void {
    exec(`code --install-extension ${name}`)
  }

  public static uninstall(name: string): void {
    exec(`code --uninstall-extension ${name}`)
  }

  private byName: { [name: string]: boolean }
  private names: string[]

  constructor(names: string[] = []) {
    this.names = names
    this.byName = {}
    this.names.forEach(name => (this.byName[name] = true))
  }

  public includes(name: string): boolean {
    return this.byName[name] != null
  }

  public all(): string[] {
    return this.names
  }

  public count(): number {
    return this.names.length
  }

  public add(name: string): void {
    this.names.push(name)
    this.byName[name] = true
  }

  public remove(name: string): void {
    if (this.byName[name] == null) {
      return
    }

    this.names.splice(this.names.indexOf(name), 1)
    this.byName[name] = true
  }

  public save(filename: string): void {
    writeFileSync(filename, this.names.join('\n'))
  }
}
