#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { Table } from "npm:console-table-printer"

const SPACES_REGEX = /\s+/
const EXCLUDE_MOUNT_POINTS = /^\/(System\/Volumes|snap)\//
const MIN_FREE_GB = 4

interface Disk {
  device: string
  used: number
  usedPercentage: number
  size: number
  availableKB: number
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
  const { device, usedPercentage, size, availableKB, mount } = disk
  return {
    mount,
    usage: `${usedPercentage}%`,
    free: prettifyKB(availableKB),
    size: prettifyKB(size),
    device,
  }
}

function main() {
  const disks = loadDisks()

  if (Deno.args.includes("-w") || Deno.args.includes("--warn")) {
    warn(disks)
    return
  }

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

  const [device, size, used, available, usedPercentage, mount] = line.trim()
    .split(SPACES_REGEX)
  return {
    device,
    used: Number(used),
    usedPercentage: Number(usedPercentage.slice(0, -1)),
    size: Number(size),
    availableKB: Number(available),
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

function warn(disks: Disk[]): void {
  for (const disk of disks) {
    const availableGB = disk.availableKB / 1024 / 1024
    if (availableGB < MIN_FREE_GB) {
      console.warn(
        `Disk "${disk.mount}" has low free space (only ${
          prettifyKB(disk.availableKB)
        })`,
      )
    }
  }
}

main()
