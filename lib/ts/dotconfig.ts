import * as fs from 'fs'
import * as os from 'os'
import * as path from 'path'
import { ask } from './utils'
import { execSync } from 'child_process'

export const CONFIG_DIR = path.join(os.homedir(), '.config', 'dotfiles')
export const CONFIG_FILE = path.join(CONFIG_DIR, 'config')

interface IConfigItem {
  key: string
  value: string
}

type ConfigLine = string | IConfigItem

let configLines: ConfigLine[] = []

function initialize(): void {
  if (!fs.existsSync(CONFIG_FILE)) return

  configLines = fs
    .readFileSync(CONFIG_FILE)
    .toString()
    .trim()
    .split('\n')
    .map(parseLine)
}

function parseLine(line: string): ConfigLine {
  if (/^[#\s]/.test(line)) return line
  const index = line.indexOf('=')
  if (index === -1) return line
  return {
    key: line.substring(0, index),
    value: line.substring(index + 1)
  }
}

function findItem(key: string): IConfigItem | undefined {
  return configLines.find(l => typeof l === 'object' && l.key === key) as IConfigItem | undefined
}

function findItemIndex(key: string): number {
  return configLines.findIndex(l => typeof l === 'object' && l.key === key)
}

export function getConfigOrDie(key: string): string {
  const value = getConfig(key)
  if (value != null) return value

  console.error(`Missing config "${key}", please set a value:\n\n  dotconfig set ${key} {value}`)
  process.exit(1)
}

export function getConfig(key: string): string | undefined {
  const item = findItem(key)
  if (item != null) return item.value
}

export function setConfig(key: string, value: string): void {
  const index = findItemIndex(key)
  if (index === -1) {
    configLines.push({ key, value })
  } else {
    configLines[index] = { key, value }
  }
  save()
}

function save(): void {
  if (!fs.existsSync(CONFIG_DIR)) execSync(`mkdir -p "${CONFIG_DIR}"`)

  const body = configLines
    .map(line => (typeof line === 'object' ? `${line.key}=${line.value}` : line))
    .join('\n')
  fs.writeFileSync(CONFIG_FILE, body)
}

export async function getConfigOrAsk(key: string, question: string): Promise<string> {
  const item = findItem(key)
  if (item != null) return item.value

  let value: string | undefined
  while (value == null) {
    value = await ask(question)
  }

  setConfig(key, value)
  return value
}

initialize()
