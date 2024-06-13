import { DEBUG } from "./helpers.ts"
import { StepMessage, StepResult } from "./step.ts"
import { print } from "./ui.ts"

export function printResult(result: StepResult, indentLevel = 0): void {
  const { step, status, items, isDebug } = result
  const { name, description } = step

  if (isDebug && !DEBUG) return

  const title = description ? `${name} (${description})` : name
  switch (status) {
    case "success":
      print.success(`${title}`, indentLevel)
      break
    case "silent-success":
      print.silentSuccess(`${title}`, indentLevel)
      break
    case "error":
      print.error(`${title}`, indentLevel)
      break
  }

  for (const item of items) {
    if ("step" in item) {
      printResult(item, indentLevel + 1)
    } else {
      printMessage(item, indentLevel + 1)
    }
  }
}

function printMessage({ type, message }: StepMessage, indentLevel = 0): void {
  switch (type) {
    case "success":
      print.success(message, indentLevel)
      return
    case "silent-success":
      print.silentSuccess(message, indentLevel)
      return
    case "warning":
      print.warning(message, indentLevel)
      return
    case "error":
      print.error(message, indentLevel)
      return
    case "info":
      print.bullet(message, indentLevel)
      return
    case "debug":
      print.debug(message, indentLevel)
      return
  }
}
