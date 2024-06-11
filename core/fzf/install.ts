import { gitClone } from "../framework/lib/git.ts"
import {
  fileExists,
  printResult,
  stepMessage,
} from "../framework/lib/helpers.ts"
import { shellStep } from "../framework/lib/shellStep.ts"
import { Step, StepItems, StepResult } from "../framework/lib/step.ts"

export async function main() {
  printResult(await installFzf())
}

async function installFzf(): Promise<StepResult> {
  const step: Step = {
    name: "Install Fzf",
  }

  const items: StepItems = []

  const cloneResult = await gitClone({
    dir: "~/.fzf",
    origin: "https://github.com/junegunn/fzf.git",
  })
  items.push(cloneResult)

  if (cloneResult.status === "error") {
    return { step, status: "error", items }
  }

  if (await fileExists("~/.fzf/bin/fzf")) {
    return {
      step,
      status: "silent-success",
      items: [
        ...items,
        stepMessage(
          "silent-sucess",
          "File ~/.fzf/bin/fzf already exists, skipping build",
        ),
      ],
    }
  }

  const installResult = await shellStep("./install", {
    cwd: "~/.fzf",
    args: ["--all"],
  })
  items.push(installResult)

  return {
    step,
    status: installResult.status,
    items,
  }
}

main()
