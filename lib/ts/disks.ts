import { execSync } from 'child_process'

export interface IDisk {
  device: string
  totalKB: number
  usedKB: number
  freeKB: number
  freeGB: number
  capacity: number
  mount: string
}

function parseDfLine(line: string) {
  const column = '([^\\s]+)\\s+'
  const re = new RegExp(`^${column}${column}${column}${column}${column}(.*)$`)
  const match = line.match(re)

  return {
    device: match[1],
    totalKB: parseInt(match[2], 10),
    usedKB: parseInt(match[3], 10),
    freeKB: parseInt(match[4], 10),
    freeGB: parseInt(match[4], 10) / 1024 / 1024,
    capacity: parseInt(match[5], 10) / 100,
    mount: match[6]
  }
}

export function free(): IDisk[] {
  return execSync('df')
    .toString()
    .trim()
    .split('\n')
    .slice(1)
    .map(line => parseDfLine(line))
}

export function formatGB(gb: number): string {
  return `${gb.toFixed(1)}GB`
}

export function formatDisk(disk: IDisk): string {
  return `${disk.mount} (${disk.freeGB.toFixed(1)}GB free)`
}
