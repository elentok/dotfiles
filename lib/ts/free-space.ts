import { execSync } from 'child_process'
import { notUndefined, justifyLeft, justifyRight } from './utils'
import * as chalk from 'chalk'

function main(): void {
  printDisks(loadDisks())
}

enum State {
  OK = 'OK',
  GOOD = 'GOOD',
  BAD = 'BAD',
}

interface IDisk {
  device: string
  size: number
  used: string
  available: number
  capacity: string
  availableGB: string
  sizeGB: string
  mount: string
  state: State
}

interface IColumnWidths {
  [key: string]: number
}

function parseDfLine(line: string): IDisk | undefined {
  const parts = line.trim().split(/\s+/)
  const [device, size, used, available, capacity] = parts
  const mount = parts[parts.length - 1]

  if (device === 'Filesystem') return
  if (!RELEVANT_MOUNT_POINT.test(mount)) return

  return {
    device,
    size: Number(size),
    used,
    available: Number(available),
    capacity,
    availableGB: sizeToGB(available),
    sizeGB: sizeToGB(size),
    mount,
    state: calculateState(capacity),
  }
}

const RELEVANT_MOUNT_POINT = new RegExp('/($|Volumes|media|usr|mnt)')

function sizeToGB(value: string): string {
  return (parseFloat(value) / 1024 / 1024).toFixed(1)
}

function calculateState(capacity: string): State {
  const c = parseInt(capacity, 10)
  if (c > 90) return State.BAD
  if (c > 70) return State.OK
  return State.GOOD
}

function loadDisks(): IDisk[] {
  return execSync('df').toString().split('\n').map(parseDfLine).filter(notUndefined)
}

function printDisks(disks: IDisk[]): void {
  const columnWidths = calculateColumnWidths(disks)
  disks.forEach((disk) => console.info(stringifyDisk(disk, columnWidths)))
}

function stringifyDisk(disk: IDisk, widths: IColumnWidths): string {
  const { capacity, availableGB, sizeGB, mount, device } = disk
  let part1 = [
    justifyRight(capacity, widths.capacity),
    justifyRight(availableGB, widths.availableGB) + 'G',
    'free (of',
    justifyRight(sizeGB, widths.sizeGB) + 'G)',
    justifyLeft(mount, widths.mount),
  ].join(' ')
  switch (disk.state) {
    case State.GOOD:
      part1 = chalk.green(part1)
      break
    case State.OK:
      part1 = chalk.yellow(part1)
      break
    case State.BAD:
      part1 = chalk.red(part1)
      break
  }

  return [part1, chalk.grey(`(${device})`)].join(' ')
}

function calculateColumnWidths(disks: IDisk[]): IColumnWidths {
  const widths: IColumnWidths = {}
  disks.forEach((disk) => {
    Object.keys(disk).forEach((key) => {
      const width = widths[key] || 0
      const value = (disk as any)[key].toString()
      widths[key] = Math.max(width, value.length)
    })
  })
  return widths
}

main()
