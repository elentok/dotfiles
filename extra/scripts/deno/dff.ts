#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { Table, printTable } from "npm:console-table-printer"

const SPACES_REGEX = /\s+/

interface Disk {
  device: string
  used: string
  usedPercentage: number
  size: number
  available: number
  mount: string
}

function main() {
  const disks = loadDisks()

  const table = new Table({
    columns: [
      {
        name: "device",
        title: "Device",
        alignment: "left",
      },
      {
        name: "mount",
        title: "Mountpoint",
        alignment: "left",
      },
    ],
  })

  table.addRows(disks)
  table.printTable()

  // printTable(disks)
  // console.table(disks)
  // for (const disk of ) {
  //   console.log("abc")
  //   console.log(disk)
  // }
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
    used: prettifyKB(Number(used)),
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
  return lines.map(parseDisk).filter(isPresent)
}

function isPresent<T>(value: T | null | undefined): value is T {
  return value != null
}

main()
