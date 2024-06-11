import { StepMessage, StepResult } from "./step.ts"
import { print } from "./ui.ts"

export function expandPath(path: string): string {
  return path.replace(/^~/, Deno.env.get("HOME") ?? "~")
}

export function stepMessage(
  type: StepMessage["type"],
  message: StepMessage["message"],
): StepMessage {
  return { type, message }
}

export async function dirExists(dir: string): Promise<boolean> {
  try {
    return (await Deno.stat(expandPath(dir))).isDirectory
  } catch {
    return false
  }
}

export async function fileExists(filepath: string): Promise<boolean> {
  try {
    return (await Deno.stat(expandPath(filepath))).isFile
  } catch {
    return false
  }
}

export function printResult(result: StepResult, indentLevel = 0): void {
  const { step, status, items } = result
  const { name, description } = step

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
