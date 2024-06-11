import chalk from "npm:chalk"
import { StepMessage, StepResult } from "./types.ts"
import { print } from "./ui.ts"

export function expandPath(path: string): string {
  return path.replace(/^~/, Deno.env.get("HOME") ?? "~")
}

export function failStep(messages: StepMessage[]): StepResult {
  return { isSuccess: false, messages }
}

export function passStep(messages: StepMessage[]): StepResult {
  return { isSuccess: true, messages }
}

export function extendStep(
  result: StepResult,
  { before, after }: { before?: StepMessage[]; after?: StepMessage[] } = {},
): StepResult {
  return {
    isSuccess: result.isSuccess,
    messages: [...(before ?? []), ...result.messages, ...(after ?? [])],
  }
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

export function printResult(result: StepResult): void {
  if (result.isSuccess) {
    print.success("SUCCESS")
  } else {
    print.error("FAILURE")
  }

  for (const message of result.messages) {
    printMessage(message)
  }
}

function printMessage({ type, message }: StepMessage): void {
  switch (type) {
    case "success":
      print.success(message)
      return
    case "silent-sucess":
      print.silentSuccess(message)
      return
    case "warning":
      print.warning(message)
      return
    case "error":
      print.error(message)
      return
    case "info":
      print.bullet(message)
      return
    case "debug":
      print.debug(message)
      return
  }
}
