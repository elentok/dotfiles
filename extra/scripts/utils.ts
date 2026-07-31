import * as fs from "node:fs"

export function getStdInput(): string {
  const chunks: Buffer[] = []
  const buf = Buffer.alloc(65536)

  while (true) {
    let bytesRead: number
    try {
      bytesRead = fs.readSync(0, buf, 0, buf.length, null)
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code === "EAGAIN") continue
      if ((error as NodeJS.ErrnoException).code === "EOF") break
      throw error
    }
    if (bytesRead === 0) break
    chunks.push(Buffer.from(buf.subarray(0, bytesRead)))
  }

  return Buffer.concat(chunks).toString("utf8")
}
