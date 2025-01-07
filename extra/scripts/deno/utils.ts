import { readAllSync } from "jsr:@std/io/read-all"

export function getStdInput(): string {
  const input = readAllSync(Deno.stdin)
  return new TextDecoder().decode(input)
}
