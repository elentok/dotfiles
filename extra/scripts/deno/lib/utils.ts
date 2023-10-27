export function center(text: string, width: number, ch = " "): string {
  if (text.length >= width) return text

  const leftPad = Math.floor((width - text.length) / 2)
  const rightPad = width - text.length - leftPad

  return `${ch.repeat(leftPad)}${text}${ch.repeat(rightPad)}`
}

export class NonZeroExitCodeError extends Error {}

export function execSync(command: string, options?: Deno.CommandOptions): string {
  const p = new Deno.Command(command, options)
  const { code, stdout, stderr } = p.outputSync()
  if (code !== 0) {
    throw new NonZeroExitCodeError(`Error occured while running "${command}":\n${stderr}`)
  }

  return new TextDecoder().decode(stdout)
}
