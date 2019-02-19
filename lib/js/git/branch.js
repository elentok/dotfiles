"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Branch {
    constructor(repo, name) {
        this.repo = repo;
        this.name = name;
        this.gitName = name;
    }
    hash() {
        if (this.cachedHash == null) {
            this.cachedHash = this.repo.git(`log -1 --pretty=%h ${this.gitName}`, { silent: true });
        }
        return this.cachedHash;
    }
    resetHash() {
        this.cachedHash = null;
    }
    toString() {
        return this.gitName;
    }
    isProtected() {
        return ['master', 'develop', 'protected'].indexOf(this.name) !== null;
    }
}
class LocalBranch extends Branch {
    constructor() {
        super(...arguments);
        this.remoteBranches = [];
    }
    hasRemotes() {
        return this.remoteBranches.length > 0;
    }
    destroy({ force = false } = {}) {
        const arg = force ? '-D' : '-d';
        return this.repo.git(`branch ${arg} ${this.name}`);
    }
}
exports.LocalBranch = LocalBranch;
class RemoteBranch extends Branch {
    constructor(repo, name) {
        super(repo, name);
        name = name.replace(/ ->.*/g, '');
        const parts = name.split('/', 3);
        this.remoteName = parts[1];
        this.name = parts[2];
        this.gitName = `${this.remoteName}/${this.name}`;
    }
    destroy() {
        return this.repo.git(`push --delete ${this.remoteName} ${this.name}`);
    }
}
exports.RemoteBranch = RemoteBranch;
function parseBranchLine(line, repo) {
    line = line.replace(/^\*/g, '').trim();
    if (line.match(/^remotes\//)) {
        return new RemoteBranch(repo, line);
    }
    else {
        return new LocalBranch(repo, line);
    }
}
exports.parseBranchLine = parseBranchLine;
