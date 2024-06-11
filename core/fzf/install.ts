import { gitClone } from "../framework/lib/git.ts"
import { printResult } from "../framework/lib/helpers.ts"

export async function main() {
  const result = await gitClone({
    dir: "~/.fzf",
    origin: "https://github.com/junegunn/fzf.git",
  })
  printResult(result)
}

main()
