import { stepMessage } from "./helpers.ts"
import { shell, ShellOptions, ShellResult } from "./shell.ts"
import { Step, StepResult } from "./step.ts"

export type ShellStepResult = StepResult & Omit<ShellResult, "success">

export async function shellStep(
  cmd: string,
  options?: ShellOptions & { isDebug?: boolean },
): Promise<ShellStepResult> {
  const fullCmd = [cmd, options?.args?.join(" ")].filter(Boolean).join(" ")
  const step: Step = {
    name: `Run ${fullCmd}`,
  }

  const result = await shell(cmd, { throwError: false, ...options })
  const items = result.success
    ? [stepMessage("debug", `Command ${fullCmd} completed successfuly`)]
    : [
      stepMessage(
        "error",
        `Command "${fullCmd}" failed with exitcode ${result.code}: ${result.stderr}`,
      ),
    ]

  return {
    step,
    status: result.success ? "success" : "error",
    ...result,
    isDebug: options?.isDebug ?? true,
    items,
  }
}
