import { copyFileSync, readFileSync, statSync } from 'fs'
import { join, resolve } from 'path'
import { exec } from 'shelljs'
import ExtensionSyncer from './extension_syncer'

class Syncer {
  private configPath: string

  constructor() {
    this.configPath = this.getConfigPath()
  }

  public run(): void {
    this.syncConfigFiles('settings.json')
    this.syncConfigFiles('keybindings.json')
    new ExtensionSyncer(this.configPath).run()
  }

  private getConfigPath(): string {
    switch (process.platform) {
      case 'win32':
        return join(process.env.USERPROFILE, 'AppData', 'Roaming', 'Code')

      case 'darwin':
        return join(process.env.HOME, 'AppData', 'Roaming', 'Code')

      default:
        return join(process.env.HOME, '.config', 'Code')
    }
  }

  private syncConfigFiles(filename: string): void {
    const dotfilesPath = join(__dirname, filename)
    const vscodePath = join(this.configPath, 'User', filename)

    if (
      readFileSync(dotfilesPath).toString() ===
      readFileSync(vscodePath).toString()
    ) {
      return
    }

    console.info(`Config file '${filename}' has changed`)

    const dotfilesStat = statSync(dotfilesPath)
    const vscodeStat = statSync(vscodePath)

    if (dotfilesStat.mtime > vscodeStat.mtime) {
      console.info('  Using dotfiles version')
      copyFileSync(dotfilesPath, vscodePath)
    } else {
      console.info('  Updating dotfiles version')
      copyFileSync(vscodePath, dotfilesPath)
    }
  }
}
new Syncer().run()
