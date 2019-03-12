import * as program from 'commander'
import * as path from 'path'
import * as fs from 'fs'
import chalk from 'chalk'
import { execSync } from 'child_process'

function main() {
  program
    .arguments('<pattern> <replacement> <file...>')
    .option('-y, --yes', "Don't ask for confirmation")
    .action((pattern: string, replacement: string, files: string[], args: IArgs) => {
      const matches = findMatches(pattern, replacement, files)
      if (matches.length === 0) {
        console.info('No matches')
        return
      }
    })

  program.parse(process.argv)
}

function findMatches(pattern: string, replacement: string, files: string[]): Match[] {
  const re = new RegExp(pattern, 'ig')
  const matches: Match[] = []

  files.forEach(filename => {
    const basename = path.basename(filename)
    const newBasename = basename.replace(re, replacement)

    if (basename !== newBasename) matches.push(new Match(filename, newBasename))
  })

  return matches
}

class Match {
  public fromDirname: string
  public fromBasename: string
  public toFullpath: string

  constructor(public fromFullpath: string, public toBasename: string) {
    this.fromDirname = path.dirname(fromFullpath)
    this.fromBasename = path.basename(fromFullpath)
    this.toFullpath = path.join(this.fromDirname, toBasename)
  }

  public print(prefix = ''): void {
    console.info(`${prefix}${chalk.gray(this.fromDirname)}/${this.fromBasename}`)
    console.info(`${this.indent(prefix)} => ${chalk.blue(this.toBasename)}`)
  }

  public rename(): void {
    if (this.isInGitRepo()) {
      execSync(`git mv '${this.fromFullpath}' '${this.toFullpath}'`)
    } else {
      fs.renameSync(this.fromDirname, this.toFullpath)
    }
  }

  private indent(prefix: string): string {
    let text = ''
    const indentWidth = Math.max(prefix.length + this.fromDirname.length - 3, 0)
    while (text.length < indentWidth) text += ' '
    return text
  }

  private isInGitRepo(): boolean {
    return execSync(`git ls-files --error-unmatch ${this.fromFullpath} > /dev/null 2>&1`)
  }
}

interface IArgs {
  yes?: boolean
}

main()
