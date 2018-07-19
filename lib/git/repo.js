const shell = require('shelljs')
const Remote = require('./remote')
const { Branch, RemoteBranch, LocalBranch } = require('./branch')
const Pair = require('./pair')

class Repo {
  constructor(root) {
    this.root = root
  }

  remotes() {
    if (this._remotes == null) {
      this._remotes = this.git('remote', { silent: true })
        .split('\n')
        .map(name => new Remote(this, name))
    }

    return this._remotes
  }

  localBranches() {
    if (this._localBranches == null) this._loadBranches()
    return Object.values(this._localBranches)
  }

  remoteBranches() {
    if (this._remoteBranches == null) this._loadBranches()
    return Object.values(this._remoteBranches)
  }

  _loadBranches() {
    this._localBranches = {}
    this._remoteBranches = {}

    this.git('branch --all', { silent: true })
      .split('\n')
      .forEach(line => {
        const branch = Branch.parse(line, this)
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

    this._addRemotesToLocalBranches()
  }

  _addRemotesToLocalBranches() {
    Object.keys(this._remoteBranches).forEach(name => {
      this._remoteBranches[name].forEach(remoteBranch => {
        const localBranch = this._localBranches[name]
        if (localBranch != null) {
          localBranch.remoteBranches.push(remoteBranch)
        }
      })
    })
  }

  findLocalBranchByName(name) {
    if (this._localBranches == null) this._loadBranches()
    return this._localBranches[name]
  }

  findRemoteBranchesByName(name) {
    if (this._remoteBranches == null) this._loadBranches()
    return this._remoteBranches[name]
  }

  fetchRemotes() {
    this.remotes()
      .filter(r => r.name !== 'review')
      .forEach(r => {
        r.fetch()
        r.prune()
      })
  }

  unsyncedBranches() {
    const pairs = []

    this.localBranches().forEach(local => {
      local.remoteBranches.forEach(remote => {
        if (local.hash() !== remote.hash()) {
          pairs.push(new Pair(local, remote))
        }
      })
    })

    return pairs
  }

  git(command, options = {}) {
    shell.cd(this.root)
    const result = shell.exec(`git ${command}`, options)

    if (result.code !== 0) {
      throw new Error(`Git command returns status ${result.code}:\n${result.stderr.toString()}`)
    }

    return result.stdout.toString().trim()
  }
}

module.exports = Repo
