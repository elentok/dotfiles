import { join } from 'path'
import * as prompt from 'prompt'
import Extensions from './extensions'

interface IAnswers {
  [extension: string]: string
}

/*

How it works?

Compare installed extensions and extensions.txt,
ask the user what to do about:

1. Extensions in extensions.txt that aren't installed: install/remove
2. Installed extensions not in extensions.txt: add/uninstall

*/

export default class ExtensionSyncer {
  private configPath: string
  private dotfilesFilepath: string
  private dotfiles: Extensions
  private installed: Extensions

  constructor(configPath: string) {
    this.dotfilesFilepath = join(__dirname, 'extensions.txt')
    this.dotfiles = Extensions.fromTextFile(this.dotfilesFilepath)
    this.installed = Extensions.fromVSCode()
  }

  public run() {
    if (this.installed.count() === 0) {
      this.dotfiles.all().forEach(name => Extensions.install(name))
      return
    }

    this.analyze().then(result => {
      Object.keys(result).forEach(extension => {
        const action = result[extension]
        this.runAction(extension, action)
      })
      this.dotfiles.save(this.dotfilesFilepath)
    })
  }

  private runAction(extension: string, action: string) {
    switch (action) {
      case 'i':
        Extensions.install(extension)
        break
      case 'u':
        Extensions.uninstall(extension)
        break
      case 'a':
        this.dotfiles.add(extension)
        break
      case 'r':
        this.dotfiles.remove(extension)
        break
    }
  }

  private analyze(): Promise<IAnswers> {
    return new Promise<IAnswers>(resolve => {
      prompt.get(this.createQuestions(), (err, result) => {
        if (err != null) {
          console.error(err)
          process.exit(1)
        } else {
          resolve(result)
        }
      })
    })
  }

  private createQuestions() {
    return this.createNotInDotfilesQuestions().concat(this.createNotInstalledQuestions())
  }

  private createNotInDotfilesQuestions() {
    return this.installed
      .all()
      .filter(ext => !this.dotfiles.includes(ext))
      .map(name => {
        return {
          description: `${name} is missing from extensions.txt, [a]dd/[u]ninstall?`,
          name,
          pattern: /^[au]$/
        }
      })
  }

  private createNotInstalledQuestions() {
    return this.dotfiles
      .all()
      .filter(ext => !this.installed.includes(ext))
      .map(name => {
        return {
          description: `${name} is not installed, [i]nstall/[r]emove?`,
          name,
          pattern: /^[ir]$/
        }
      })
  }
}
