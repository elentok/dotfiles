import * as path from "path";
import * as chalk from "chalk";
import { execSync } from "child_process";
import { mv } from "shelljs";

export function findRenameables(
  pattern: string,
  replacement: string,
  files: string[]
): Renameable[] {
  const re = new RegExp(pattern, "ig");
  const matches: Renameable[] = [];

  files.forEach((filename) => {
    const basename = path.basename(filename);
    const newBasename = basename.replace(re, replacement);

    if (basename !== newBasename) matches.push(new Renameable(filename, newBasename));
  });

  return matches;
}

export class Renameable {
  public fromDirname: string;
  public fromBasename: string;
  public toFullpath: string;

  constructor(public fromFullpath: string, public toBasename: string) {
    this.fromDirname = path.dirname(fromFullpath);
    this.fromBasename = path.basename(fromFullpath);
    this.toFullpath = path.join(this.fromDirname, toBasename);
  }

  public print(prefix = ""): void {
    console.info(`${prefix}${chalk.gray(this.fromDirname)}/${this.fromBasename}`);
    console.info(`${this.indent(prefix)} => ${chalk.blue(this.toBasename)}`);
  }

  public rename(): void {
    if (this.isInGitRepo()) {
      execSync(`git mv '${this.fromFullpath}' '${this.toFullpath}'`);
    } else {
      mv(this.fromFullpath, this.toFullpath);
    }
  }

  private indent(prefix: string): string {
    let text = "";
    const indentWidth = Math.max(prefix.length + this.fromDirname.length - 3, 0);
    while (text.length < indentWidth) text += " ";
    return text;
  }

  private isInGitRepo(): boolean {
    try {
      execSync(`git ls-files --error-unmatch ${this.fromFullpath} > /dev/null 2>&1`);
      return true;
    } catch (error) {
      return false;
    }
  }
}
