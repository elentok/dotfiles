import { stepMessage } from "./helpers.ts"
import { failStep, passStep, Step, StepResult } from "./step.ts"

export async function deleteFileStep(filename: string): Promise<StepResult> {
  const step: Step = {
    name: `Delete ${filename}`,
  }

  try {
    await Deno.remove(filename)
  } catch (err) {
    return failStep(step, [
      stepMessage("error", `Failed to remove ${filename}: ${err}`),
    ])
  }

  return passStep(step, [
    stepMessage("info", `Deleted ${filename}`),
  ])
}

export async function renameStep(
  oldFilename: string,
  newFilename: string,
): Promise<StepResult> {
  const step: Step = {
    name: `Rename ${oldFilename} to ${newFilename}`,
  }

  try {
    await Deno.rename(oldFilename, newFilename)
  } catch (err) {
    return failStep(step, [
      stepMessage("error", `Failed to rename ${oldFilename}: ${err}`),
    ])
  }

  return passStep(step, [
    stepMessage("info", `Renamed ${oldFilename} to ${newFilename}`),
  ])
}
