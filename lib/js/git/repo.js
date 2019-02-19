"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const remote_1 = require("./remote");
const shell = require("shelljs");
const branch_1 = require("./branch");
class Repo {
    constructor(root) {
        this.root = root;
    }
    remotes() {
        if (this._remotes == null) {
            this._remotes = this.git('remote', { silent: true })
                .split('\n')
                .map(name => new remote_1.Remote(this, name));
        }
        return this._remotes;
    }
    localBranches() {
        if (this._localBranches == null)
            this.loadBranches();
        return Object.values(this._localBranches);
    }
    remoteBranches() {
        if (this._remoteBranches == null)
            this.loadBranches();
        return [].concat(...Object.values(this._remoteBranches));
    }
    findLocalBranchByName(name) {
        if (this._localBranches == null)
            this.loadBranches();
        return this._localBranches[name];
    }
    findRemoteBranchesByName(name) {
        if (this._remoteBranches == null)
            this.loadBranches();
        return this._remoteBranches[name];
    }
    fetchRemotes() {
        this.remotes()
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
    loadBranches() {
        this._localBranches = {};
        this._remoteBranches = {};
        this.git('branch --all', { silent: true })
            .split('\n')
            .forEach(line => {
            const branch = branch_1.parseBranchLine(line, this);
            if (branch.name === 'HEAD')
                return;
            if (branch instanceof branch_1.RemoteBranch) {
                if (this._remoteBranches[branch.name] == null) {
                    this._remoteBranches[branch.name] = [];
                }
                this._remoteBranches[branch.name].push(branch);
            }
            else {
                this._localBranches[branch.name] = branch;
            }
        });
        this.addRemotesToLocalBranches();
    }
    addRemotesToLocalBranches() {
        Object.keys(this._remoteBranches).forEach(name => {
            this._remoteBranches[name].forEach(remoteBranch => {
                const localBranch = this._localBranches[name];
                if (localBranch != null) {
                    localBranch.remoteBranches.push(remoteBranch);
                }
            });
        });
    }
}
exports.Repo = Repo;
