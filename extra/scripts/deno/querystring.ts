#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { readAllSync } from "jsr:@std/io"

function main() {
  if (Deno.args.length < 1) {
    console.info("Usage: querystring.ts <querystring> [key]")
    console.info()
    console.info('Tip: Use "-" to read from stdin')
    Deno.exit(1)
  }

  const input = Deno.args[0] === "-" ? getStdInput() : Deno.args[0]
  const key = Deno.args[1]

  const params = parse(input)
  if (key == null) {
    prettyPrint(params)
  } else {
    console.info(params.getAll(key))
  }
}

function getStdInput(): string {
  const input = readAllSync(Deno.stdin)
  return new TextDecoder().decode(input)
}

function parse(str: string): URLSearchParams {
  try {
    return new URL(str).searchParams
  } catch {
    return new URLSearchParams(str)
  }
}

function prettyPrint(params: URLSearchParams): void {
  for (const [key, value] of params.entries()) {
    console.info(`- ${key}: ${value}`)
  }
}

main()
