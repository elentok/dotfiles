import { exec, config } from 'shelljs'
import { join, resolve } from 'path'
import { platform } from 'os'
import { statSync, readFileSync } from 'fs'
import * as fs from 'fs'

let configPath

function main(): void {
  configPath = getConfigPath()
  installExtensions()
  compareConfigFiles('settings.json')
  compareConfigFiles('keybindings.json')
}

function compareConfigFiles(filename: string): void {
  const dotfilesPath = join(__dirname, filename)
  const vscodePath = join(configPath, 'User', filename)

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
    fs.copyFileSync(dotfilesPath, vscodePath)
  } else {
    console.info('  Updating dotfiles version')
    fs.copyFileSync(vscodePath, dotfilesPath)
  }
}

function getConfigPath(): string {
  switch (process.platform) {
    case 'win32':
      return join(process.env.USERPROFILE, 'AppData', 'Roaming', 'Code')

    case 'darwin':
      return join(process.env.HOME, 'AppData', 'Roaming', 'Code')

    default:
      return join(process.env.HOME, '.config', 'Code')
  }
}

const extensions = [
  'castwide.solargraph',
  'davidpallinder.rails-test-runner',
  'dbaeumer.vscode-eslint',
  'donjayamanne.githistory',
  'eamodio.gitlens',
  'esbenp.prettier-vscode',
  'gamunu.vscode-yarn',
  'karunamurti.haml',
  'leizongmin.node-module-intellisense',
  'lkytal.coffeelinter',
  'miguel-savignano.ruby-symbols',
  'ms-vscode.cpptools',
  'ms-vscode.Go',
  'ms-vscode.PowerShell',
  'PeterJausovec.vscode-docker',
  'rebornix.Ruby',
  'Shan.code-settings-sync',
  'sleistner.vscode-fileutils',
  'slevesque.vscode-autohotkey',
  'streetsidesoftware.code-spell-checker',
  'vscodevim.vim',
  'yzhang.dictionary-completion',
  'yzhang.markdown-all-in-one'
]

function installExtensions() {
  const isInstalled: { [extension: string]: boolean } = {}
  const installedExtensions = exec(`code --list-extensions`, { silent: true })
    .stdout.toString()
    .trim()
    .split('\n')
    .forEach(e => (isInstalled[e] = true))

  extensions.forEach(name => {
    if (!isInstalled[name]) {
      exec(`code --install-extension ${name}`)
    }
  })
}

main()
