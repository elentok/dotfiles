import { deleteFileStep, renameStep } from "./fsSteps.ts"
import { fileExists, stepMessage } from "./helpers.ts"
import { failStep, Step, StepItems, StepResult } from "./step.ts"

export async function backup(filename: string): Promise<StepResult> {
  const backupFilename = `${filename}.backup`

  const step: Step = {
    name: "Backup",
    description: `File ${filename} exists, backing up to ${backupFilename}`,
  }

  const items: StepItems = []

  if (await fileExists(backupFilename)) {
    items.push(
      stepMessage("info", `Backup filename already exists, overwriting`),
    )
    const deleteResult = await deleteFileStep(backupFilename)
    items.push(deleteResult)

    if (!deleteResult.status) {
      return failStep(step, items)
    }
  }

  const renameResult = await renameStep(filename, backupFilename)
  items.push(renameResult)
  return {
    step,
    status: renameResult.status,
    items,
  }
}
