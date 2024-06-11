import { backup } from "./backup.ts"
import {
  dirExists,
  expandPath,
  extendStep,
  failStep,
  passStep,
  stepMessage,
} from "./helpers.ts"
import { shell } from "./shell.ts"
import { StepMessage, StepResult } from "./types.ts"
import * as path from "jsr:@std/path"

export interface GitCloneOptions {
  origin: string
  dir: string
  update?: boolean
}

export async function gitClone(opts: GitCloneOptions): Promise<StepResult> {
  const dir = expandPath(opts.dir)

  let messages: StepMessage[] = [
    stepMessage("info", `Cloning ${opts.origin} to ${dir}`),
  ]

  if (await dirExists(dir)) {
    if (await dirExists(path.join(dir, ".git"))) {
      const currentOriginResult = await getOriginUrl(dir)
      messages = [...messages, ...currentOriginResult.messages]
      if (!currentOriginResult.isSuccess) {
        return failStep(messages)
      }

      if (currentOriginResult.stdout === opts.origin) {
        if (opts.update) {
          messages.push(
            stepMessage("silent-sucess", "already cloned, just updating"),
          )
          const pullResult = await git(dir, ["pull"])
          return extendStep(pullResult, { before: messages })
        } else {
          return passStep([
            ...messages,
            stepMessage("silent-sucess", "already cloned"),
          ])
        }
      }
    }

    const backupResult = await backup(dir)
    messages = [...messages, ...backupResult.messages]
    if (!backupResult.isSuccess) {
      return failStep(messages)
    }
  }

  const cloneResult = await git(Deno.env.get("HOME")!, [
    "clone",
    opts.origin,
    dir,
  ])
  return extendStep(cloneResult, { before: messages })
}

export async function getOriginUrl(dir: string): Promise<GitResult> {
  return await git(dir, ["remote", "get-url", "origin"])
}

export type GitResult = StepResult & { stdout: string }

export async function git(cwd: string, args: string[]): Promise<GitResult> {
  const cmd = `git ${args.join(" ")}`
  const messages: StepMessage[] = [stepMessage("debug", `Running "${cmd}"`)]

  const result = await shell("git", { args, cwd, throwError: false })
  if (result.success) {
    return {
      isSuccess: true,
      stdout: result.stdout,
      messages: [
        ...messages,
        stepMessage("debug", `command "${cmd}" succeeded: ${result.stdout}`),
      ],
    }
  }

  return {
    isSuccess: false,
    stdout: result.stdout,
    messages: [
      ...messages,
      stepMessage(
        "error",
        `command "${cmd}" failed: stdout:[${result.stdout}], stderr:[${result.stderr}]`,
      ),
    ],
  }
}
