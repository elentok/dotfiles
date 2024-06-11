import { backup } from "./backup.ts"
import { dirExists, expandPath, stepMessage } from "./helpers.ts"
import { shellStep, ShellStepResult } from "./shellStep.ts"
import { failStep, passStep, Step, StepItems, StepResult } from "./step.ts"
import * as path from "jsr:@std/path"

export interface GitCloneOptions {
  origin: string
  dir: string
  update?: boolean
}

export async function gitClone(opts: GitCloneOptions): Promise<StepResult> {
  const dir = expandPath(opts.dir)

  const step: Step = {
    name: `Git Clone ${opts.origin} to ${dir}`,
  }

  const items: StepItems = []

  if (await dirExists(dir)) {
    if (await dirExists(path.join(dir, ".git"))) {
      const currentOriginResult = await getOriginUrl(dir)
      items.push(currentOriginResult)

      if (!currentOriginResult.isSuccess) {
        return failStep(step, items)
      }

      if (currentOriginResult.stdout === opts.origin) {
        if (opts.update) {
          items.push(
            stepMessage("silent-sucess", "already cloned, just updating"),
          )
          const pullResult = await git(dir, ["pull"])
          items.push(pullResult)

          return {
            step,
            isSuccess: pullResult.isSuccess,
            items,
          }
        } else {
          return passStep(step, [
            stepMessage("silent-sucess", "already cloned"),
          ])
        }
      }
    }

    const backupResult = await backup(dir)
    items.push(backupResult)

    if (!backupResult.isSuccess) {
      return failStep(step, items)
    }
  }

  const cloneResult = await git(Deno.env.get("HOME")!, [
    "clone",
    opts.origin,
    dir,
  ])
  items.push(cloneResult)

  return {
    step,
    isSuccess: cloneResult.isSuccess,
    items,
  }
}

export async function getOriginUrl(dir: string): Promise<ShellStepResult> {
  return await git(dir, ["remote", "get-url", "origin"])
}

export async function git(
  cwd: string,
  args: string[],
): Promise<ShellStepResult> {
  return await shellStep("git", { args, cwd })
}
