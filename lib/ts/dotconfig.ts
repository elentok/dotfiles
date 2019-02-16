import * as os from 'os'
import * as path from 'path'
import * as fs from 'fs'
import { ask } from './utils'

export const CONFIG_DIR = path.join(os.homedir(), '.config', 'dotfiles')
export const CONFIG_FILE = path.join(CONFIG_DIR, 'config')

interface IConfigItem {
  key: string
  value: string
}

type ConfigLine = string | IConfigItem

let configLines: ConfigLine[] = []

function initialize() {
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

function save() {
  const body = configLines
    .map(line => (typeof line === 'object' ? `${line.key}=${line.value}` : line))
    .join('\n')
  fs.writeFileSync(CONFIG_FILE, body)
}

export async function getConfigOrAsk(key: string, question: string): Promise<string | undefined> {
  const item = findItem(key)
  if (item != null) return item.value

  let value: string
  while (value == null) {
    value = await ask(question)
  }

  setConfig(key, value)
  return value
}

initialize()
