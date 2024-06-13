import { StepMessage } from "./step.ts"

export const DEBUG = Deno.env.get("DEBUG") === "yes"

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
