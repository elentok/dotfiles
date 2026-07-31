import * as fs from "node:fs"
import * as path from "node:path"

export const CONFIG_DIR = path.join(
  process.env.HOME!,
  ".config",
  "dotfiles",
)
export const CONFIG_FILE = path.join(CONFIG_DIR, "config")

interface ConfigItem {
  key: string
  value: string
}

type ConfigLine = string | ConfigItem

let configLines: ConfigLine[] = []

function initialize(): void {
  if (!fs.existsSync(CONFIG_FILE)) {
    return
  }

  configLines = fs.readFileSync(CONFIG_FILE, "utf8").trim().split("\n")
    .map(parseLine)
}

function parseLine(line: string): ConfigLine {
  if (/^[#\s]/.test(line)) return line
  const index = line.indexOf("=")
  if (index === -1) return line
  return {
    key: line.substring(0, index),
    value: line.substring(index + 1),
  }
}

function findItem(key: string): ConfigItem | undefined {
  return configLines.find((l) => typeof l === "object" && l.key === key) as
    | ConfigItem
    | undefined
}

function findItemIndex(key: string): number {
  return configLines.findIndex((l) => typeof l === "object" && l.key === key)
}

function isConfigItem(line: ConfigLine): line is ConfigItem {
  return typeof line === "object" && "key" in line
}

export function keys(): string[] {
  return configLines.filter(isConfigItem).map((l) => l.key)
}

export function getConfigOrDie(key: string): string | never {
  const value = getConfig(key)
  if (value != null) return value

  console.error(
    `Missing config "${key}", please set a value:\n\n  dotconfig set ${key} {value}`,
  )
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
  fs.mkdirSync(CONFIG_DIR, { recursive: true })

  const body = configLines
    .map((
      line,
    ) => (typeof line === "object" ? `${line.key}=${line.value}` : line))
    .join("\n")
  fs.writeFileSync(CONFIG_FILE, body)
}

function prompt(question: string): string | null {
  process.stdout.write(`${question} `)
  const buf = Buffer.alloc(1024)
  let input = ""
  while (!input.includes("\n")) {
    const bytesRead = fs.readSync(0, buf, 0, buf.length, null)
    if (bytesRead === 0) break
    input += buf.toString("utf8", 0, bytesRead)
  }
  const line = input.split("\n")[0].trim()
  return line.length === 0 ? null : line
}

export function getConfigOrAsk(
  key: string,
  question: string,
): string {
  const item = findItem(key)
  if (item != null) return item.value

  let value: string | null = null
  while (value == null) {
    value = prompt(question)
  }

  setConfig(key, value)
  return value
}

initialize()
