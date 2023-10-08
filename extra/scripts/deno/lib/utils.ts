export function center(text: string, width: number, ch = " "): string {
  if (text.length >= width) return text

  const leftPad = Math.floor((width - text.length) / 2)
  const rightPad = width - text.length - leftPad

  return `${ch.repeat(leftPad)}${text}${ch.repeat(rightPad)}`
}
