import { failStep } from "./helpers.ts"
import { passStep } from "./helpers.ts"
import { fileExists, stepMessage } from "./helpers.ts"
import { StepMessage } from "./types.ts"

export async function backup(filename: string): Promise<StepResult> {
  const backupFilename = `${filename}.backup`
  const messages: StepMessage[] = [
    stepMessage(
      "info",
      `File ${filename} exists, backing up to ${backupFilename}`,
    ),
  ]

  if (await fileExists(backupFilename)) {
    messages.push(
      stepMessage("info", `Backup filename already exists, overwriting`),
    )
    try {
      await Deno.remove(backupFilename)
    } catch (err) {
      return failStep([
        ...messages,
        stepMessage("error", `Failed to remove ${backupFilename}: ${err}`),
      ])
    }
  }

  try {
    await Deno.rename(filename, backupFilename)
  } catch (err) {
    return failStep([
      ...messages,
      stepMessage("error", `Failed to rename ${filename}: ${err}`),
    ])
  }

  return passStep([
    ...messages,
    stepMessage("info", `Backed up ${filename} to ${backupFilename}`),
  ])
}
