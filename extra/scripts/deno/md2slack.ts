#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

const decoder = new TextDecoder()
const encoder = new TextEncoder()

for await (const chunk of Deno.stdin.readable) {
  const text = decoder.decode(chunk)

  Deno.stdout.writeSync()
}
