#!/usr/bin/env node

import * as os from "node:os"
import pc from "picocolors"

// Only interfaces that have an IPv4 address are shown.
for (const [name, addresses] of Object.entries(os.networkInterfaces())) {
  if (addresses == null) continue

  const ipv4 = addresses.filter((address) => address.family === "IPv4")
  if (ipv4.length === 0) continue

  console.info(pc.blue(name))

  for (const { address } of ipv4) {
    console.info(`  ${pc.green(`inet ${address}`)}`)
  }

  for (const address of addresses) {
    if (address.family === "IPv6") {
      const scope = address.scopeid ? `%${name}` : ""
      console.info(`  inet6 ${address.address}${scope}`)
    }
  }
}
