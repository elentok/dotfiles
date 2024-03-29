#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { Table } from "npm:console-table-printer"

const SPACES_REGEX = /\s+/
const EXCLUDE_MOUNT_POINTS = /^\/(System\/Volumes|snap)\//

interface Disk {
  device: string
  used: number
  usedPercentage: number
  size: number
  available: number
  mount: string
}

function rowColor({ usedPercentage }: Disk): string {
  if (usedPercentage > 90) {
    return "red"
  }
  if (usedPercentage > 70) {
    return "yellow"
  }
  return "green"
}

function diskToRow(disk: Disk): Record<string, string> {
  const { device, usedPercentage, size, available, mount } = disk
  return {
    mount,
    usage: `${usedPercentage}%`,
    free: prettifyKB(available),
    size: prettifyKB(size),
    device,
  }
}

function main() {
  const disks = loadDisks()

  const table = new Table({
    columns: [
      {
        name: "mount",
        title: "Mount",
        alignment: "left",
      },
      {
        name: "usage",
        title: "Usage",
        alignment: "right",
      },
      {
        name: "free",
        title: "Free",
        alignment: "right",
      },
      {
        name: "size",
        title: "Size",
        alignment: "right",
      },
      {
        name: "device",
        title: "Device",
        alignment: "left",
      },
    ],
  })

  for (const disk of disks) {
    table.addRow(diskToRow(disk), { color: rowColor(disk) })
  }

  table.printTable()
}

function prettifyKB(kb: number): string {
  const gb = (kb / 1024 / 1024).toFixed(1)
  return `${gb} G`
}

function parseDisk(line: string): Disk | undefined {
  if (!line.startsWith("/")) return

  const [device, size, used, available, usedPercentage, mount] = line.trim().split(SPACES_REGEX)
  return {
    device,
    used: Number(used),
    usedPercentage: Number(usedPercentage.slice(0, -1)),
    size: Number(size),
    available: Number(available),
    mount,
  }
}

function loadDisks(): Disk[] {
  const p = new Deno.Command("df")
  const { code, stdout, stderr } = p.outputSync()

  if (code !== 0) {
    console.error("Error occured while running 'df'")
    console.error(stderr)
    Deno.exit(code)
  }

  const lines = new TextDecoder().decode(stdout).split("\n")
  return lines
    .map(parseDisk)
    .filter(isPresent)
    .filter((disk) => !EXCLUDE_MOUNT_POINTS.test(disk.mount))
}

function isPresent<T>(value: T | null | undefined): value is T {
  return value != null
}

main()
