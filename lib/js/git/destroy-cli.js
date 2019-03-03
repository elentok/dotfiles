"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const chalk_1 = require("chalk");
const utils_1 = require("../utils");
const repo_1 = require("./repo");
const USAGE = `
Deletes branch from local and remote

Usage:

  git destroy <branch>...

`;
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        const branches = process.argv.splice(2);
        if (branches.length === 0) {
            console.info(USAGE);
            process.exit(1);
        }
        destroy(branches);
    });
}
function destroy(branchNames) {
    return __awaiter(this, void 0, void 0, function* () {
        const repo = new repo_1.Repo(process.cwd());
        branchNames.forEach((branchName) => __awaiter(this, void 0, void 0, function* () {
            console.info(chalk_1.default.blue(`* Destroying branch ${branchName}...`));
            const localBranch = repo.findLocalBranchByName(branchName);
            let remoteBranches;
            if (localBranch == null) {
                console.info(`  No local branch named ${branchName}`);
                remoteBranches = repo.findRemoteBranchesByName(branchName);
            }
            else {
                if (yield utils_1.confirm(`Destroy local branch ${branchName}`)) {
                    yield destroyLocal(localBranch);
                }
                remoteBranches = localBranch.remoteBranches;
            }
            if (remoteBranches == null || remoteBranches.length === 0) {
                console.info(`  No remote branches named ${branchName}`);
            }
            else {
                remoteBranches.forEach((remoteBranch) => __awaiter(this, void 0, void 0, function* () {
                    if (yield utils_1.confirm(`Destroy remote branch ${branchName}`)) {
                        remoteBranch.destroy();
                    }
                }));
            }
        }));
    });
}
function destroyLocal(localBranch) {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            localBranch.destroy();
        }
        catch (err) {
            console.error(`\nError while trying to destroy local branch ${localBranch.name}`);
            if (yield utils_1.confirm('force')) {
                localBranch.destroy({ force: true });
            }
        }
    });
}
main();
