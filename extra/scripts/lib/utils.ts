import { spawnSync } from "node:child_process"

export function center(text: string, width: number, ch = " "): string {
  if (text.length >= width) return text

  const leftPad = Math.floor((width - text.length) / 2)
  const rightPad = width - text.length - leftPad

  return `${ch.repeat(leftPad)}${text}${ch.repeat(rightPad)}`
}

export class NonZeroExitCodeError extends Error {}

export function execSync(command: string, args: string[] = []): string {
  const result = spawnSync(command, args, { encoding: "utf8" })
  if (result.status !== 0) {
    throw new NonZeroExitCodeError(
      `Error occured while running "${command}":\n${result.stderr}`,
    )
  }

  return result.stdout
}
