import { flatten } from 'underscore'
import { IRepo } from './types'
import { Remote } from './remote'
import * as shell from 'shelljs'
import { IPair, parseBranchLine, LocalBranch, RemoteBranch } from './branch'

export class Repo implements IRepo {
  private _remotes: Remote[]
  private _localBranches: { [key: string]: LocalBranch }
  private _remoteBranches: { [key: string]: RemoteBranch[] }

  constructor(public root: string) {}

  public remotes(): Remote[] {
    if (this._remotes == null) {
      this._remotes = this.git('remote', { silent: true })
        .split('\n')
        .map(name => new Remote(this, name))
    }

    return this._remotes
  }

  public localBranches(): LocalBranch[] {
    if (this._localBranches == null) this.loadBranches()
    return Object.values(this._localBranches)
  }

  public remoteBranches(): RemoteBranch[] {
    if (this._remoteBranches == null) this.loadBranches()
    return [].concat(...Object.values(this._remoteBranches))
  }

  public findLocalBranchByName(name: string): LocalBranch {
    if (this._localBranches == null) this.loadBranches()
    return this._localBranches[name]
  }

  public findRemoteBranchesByName(name: string): RemoteBranch[] {
    if (this._remoteBranches == null) this.loadBranches()
    return this._remoteBranches[name]
  }

  public fetchRemotes(): void {
    this.remotes()
      .filter(r => r.name !== 'review')
      .forEach(r => {
        r.fetch()
        r.prune()
      })
  }

  public unsyncedBranches(): IPair[] {
    const pairs = []

    this.localBranches().forEach(local => {
      local.remoteBranches.forEach(remote => {
        if (local.hash() !== remote.hash()) {
          pairs.push({ local, remote })
        }
      })
    })

    return pairs
  }

  public git(command: string, options: shell.ExecOptions = {}): string {
    shell.cd(this.root)
    const result = shell.exec(`git ${command}`, options) as shell.ExecOutputReturnValue

    if (result.code !== 0) {
      throw new Error(`Git command returns status ${result.code}:\n${result.stderr.toString()}`)
    }

    return result.stdout.toString().trim()
  }

  private loadBranches(): void {
    this._localBranches = {}
    this._remoteBranches = {}

    this.git('branch --all', { silent: true })
      .split('\n')
      .forEach(line => {
        const branch = parseBranchLine(line, this)
        if (branch.name === 'HEAD') return

        if (branch instanceof RemoteBranch) {
          if (this._remoteBranches[branch.name] == null) {
            this._remoteBranches[branch.name] = []
          }
          this._remoteBranches[branch.name].push(branch)
        } else {
          this._localBranches[branch.name] = branch
        }
      })

    this.addRemotesToLocalBranches()
  }

  private addRemotesToLocalBranches(): void {
    Object.keys(this._remoteBranches).forEach(name => {
      this._remoteBranches[name].forEach(remoteBranch => {
        const localBranch = this._localBranches[name]
        if (localBranch != null) {
          localBranch.remoteBranches.push(remoteBranch)
        }
      })
    })
  }
}
