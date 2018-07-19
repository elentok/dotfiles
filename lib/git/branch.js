class Branch {
  constructor(repo, name) {
    this._repo = repo
    this.name = name
    this.gitName = name
  }

  hash() {
    if (this._hash == null) {
      this._hash = this._repo.git(`log -1 --pretty=%h ${this.gitName}`, { silent: true })
    }
    return this._hash
  }

  resetHash() {
    this._hash = null
  }

  toString() {
    return this.gitName()
  }

  isProtected() {
    return ['master', 'develop'].indexOf(this.name) !== null
  }
}

class LocalBranch extends Branch {
  constructor(repo, name) {
    super(repo, name)
    this.remoteBranches = []
  }

  hasRemotes() {
    return this.remoteBranches.length > 0
  }

  destroy({ force = false } = {}) {
    const arg = force ? '-D' : '-d'
    return this._repo.git(`branch ${arg} ${this.name}`)
  }
}

class RemoteBranch extends Branch {
  constructor(repo, name) {
    super(repo, name)

    name = name.replace(/ ->.*/g, '')
    const parts = name.split('/', 3)
    this.remoteName = parts[1]
    this.name = parts[2]
    this.gitName = `${this.remoteName}/${this.name}`
  }

  destroy() {
    return this._repo.git(`push --delete ${this.remoteName} ${this.name}`)
  }
}

Branch.parse = (line, repo) => {
  line = line.replace(/^\*/g, '').trim()
  if (line.match(/^remotes\//)) {
    return new RemoteBranch(repo, line)
  } else {
    return new LocalBranch(repo, line)
  }
}

module.exports = { Branch, RemoteBranch, LocalBranch }
