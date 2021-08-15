"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Repo = void 0;
const shell = require("shelljs");
const branch_1 = require("./branch");
const remote_1 = require("./remote");
class Repo {
    constructor(root) {
        this.root = root;
        this.localBranchesByName = {};
        this.remoteBranchesByName = {};
        this.remotes = this.loadRemotes();
        this.loadBranches();
    }
    localBranches() {
        return Object.values(this.localBranchesByName);
    }
    remoteBranches() {
        return [].concat(...Object.values(this.remoteBranchesByName));
    }
    findLocalBranchByName(name) {
        if (this.localBranchesByName == null)
            this.loadBranches();
        return this.localBranchesByName[name];
    }
    findRemoteBranchesByName(name) {
        if (this.remoteBranchesByName == null)
            this.loadBranches();
        return this.remoteBranchesByName[name];
    }
    fetchRemotes() {
        this.remotes
            .filter(r => r.name !== 'review')
            .forEach(r => {
            r.fetch();
            r.prune();
        });
    }
    unsyncedBranches() {
        const pairs = [];
        this.localBranches().forEach(local => {
            local.remoteBranches.forEach(remote => {
                if (local.hash() !== remote.hash()) {
                    pairs.push({ local, remote });
                }
            });
        });
        return pairs;
    }
    git(command, options = {}) {
        shell.cd(this.root);
        const result = shell.exec(`git ${command}`, options);
        if (result.code !== 0) {
            throw new Error(`Git command returns status ${result.code}:\n${result.stderr.toString()}`);
        }
        return result.stdout.toString().trim();
    }
    loadRemotes() {
        return this.git('remote', { silent: true })
            .split('\n')
            .map(name => new remote_1.Remote(this, name));
    }
    loadBranches() {
        this.git('branch --all', { silent: true })
            .split('\n')
            .forEach(line => {
            const branch = branch_1.parseBranchLine(line, this);
            if (branch.name === 'HEAD')
                return;
            if (branch instanceof branch_1.RemoteBranch) {
                if (this.remoteBranchesByName[branch.name] == null) {
                    this.remoteBranchesByName[branch.name] = [];
                }
                this.remoteBranchesByName[branch.name].push(branch);
            }
            else {
                this.localBranchesByName[branch.name] = branch;
            }
        });
        this.addRemotesToLocalBranches();
    }
    addRemotesToLocalBranches() {
        Object.keys(this.remoteBranchesByName).forEach(name => {
            this.remoteBranchesByName[name].forEach(remoteBranch => {
                const localBranch = this.localBranchesByName[name];
                if (localBranch != null) {
                    localBranch.remoteBranches.push(remoteBranch);
                }
            });
        });
    }
}
exports.Repo = Repo;
//# sourceMappingURL=repo.js.map