import { gitClone } from "../framework/lib/git.ts"
import { fileExists, stepMessage } from "../framework/lib/helpers.ts"
import { printResult } from "../framework/lib/printResult.ts"
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
    update: true,
  })
  items.push(cloneResult)

  if (cloneResult.status === "error") {
    return { step, status: "error", items }
  }

  if (
    cloneResult.status === "silent-success" &&
    await fileExists("~/.fzf/bin/fzf")
  ) {
    return {
      step,
      status: "silent-success",
      items: [
        ...items,
        stepMessage(
          "silent-success",
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
