import * as shell from "shelljs";
import { IPair, LocalBranch, parseBranchLine, RemoteBranch } from "./branch";
import { Remote } from "./remote";
import { IRepo } from "./types";

export class Repo implements IRepo {
  public remotes: Remote[];
  public localBranchesByName: { [key: string]: LocalBranch } = {};
  public remoteBranchesByName: { [key: string]: RemoteBranch[] } = {};

  constructor(public root: string) {
    this.remotes = this.loadRemotes();
    this.loadBranches();
  }

  public localBranches(): LocalBranch[] {
    return Object.values(this.localBranchesByName);
  }

  public remoteBranches(): RemoteBranch[] {
    return ([] as RemoteBranch[]).concat(...Object.values(this.remoteBranchesByName));
  }

  public findLocalBranchByName(name: string): LocalBranch {
    if (this.localBranchesByName == null) this.loadBranches();
    return this.localBranchesByName[name];
  }

  public findRemoteBranchesByName(name: string): RemoteBranch[] {
    if (this.remoteBranchesByName == null) this.loadBranches();
    return this.remoteBranchesByName[name];
  }

  public fetchRemotes(): void {
    this.remotes
      .filter((r) => r.name !== "review")
      .forEach((r) => {
        r.fetch();
        r.prune();
      });
  }

  public unsyncedBranches(): IPair[] {
    const pairs: IPair[] = [];

    this.localBranches().forEach((local) => {
      local.remoteBranches.forEach((remote) => {
        if (local.hash() !== remote.hash()) {
          pairs.push({ local, remote });
        }
      });
    });

    return pairs;
  }

  public git(command: string, options: shell.ExecOptions = {}): string {
    shell.cd(this.root);
    const result = shell.exec(`git ${command}`, options) as shell.ExecOutputReturnValue;

    if (result.code !== 0) {
      throw new Error(`Git command returns status ${result.code}:\n${result.stderr.toString()}`);
    }

    return result.stdout.toString().trim();
  }

  private loadRemotes(): Remote[] {
    return this.git("remote", { silent: true })
      .split("\n")
      .map((name) => new Remote(this, name));
  }

  private loadBranches(): void {
    this.git("branch --all", { silent: true })
      .split("\n")
      .forEach((line) => {
        const branch = parseBranchLine(line, this);
        if (branch.name === "HEAD") return;

        if (branch instanceof RemoteBranch) {
          if (this.remoteBranchesByName[branch.name] == null) {
            this.remoteBranchesByName[branch.name] = [];
          }
          this.remoteBranchesByName[branch.name].push(branch);
        } else {
          this.localBranchesByName[branch.name] = branch;
        }
      });

    this.addRemotesToLocalBranches();
  }

  private addRemotesToLocalBranches(): void {
    Object.keys(this.remoteBranchesByName).forEach((name) => {
      this.remoteBranchesByName[name].forEach((remoteBranch) => {
        const localBranch = this.localBranchesByName[name];
        if (localBranch != null) {
          localBranch.remoteBranches.push(remoteBranch);
        }
      });
    });
  }
}
