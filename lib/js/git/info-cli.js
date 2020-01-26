"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const program = require("commander");
const repo_1 = require("./repo");
let repo;
function getRepo() {
    if (repo == null) {
        repo = new repo_1.Repo(process.cwd());
        if (program.quick == null)
            repo.fetchRemotes();
    }
    return repo;
}
function printRemotelessBranches() {
    getRepo()
        .localBranches()
        .filter(branch => !branch.hasRemotes() && isSafe(branch))
        .forEach(branch => console.info(branch.gitName));
}
function isSafe(branch) {
    if (program.safe == null)
        return true;
    return !['master', 'develop'].includes(branch.gitName);
}
function printAllInfo() {
    console.info('Local branches:');
    getRepo()
        .localBranches()
        .forEach(branch => {
        console.info(`- ${branch.gitName} (${branch.hash()})${branch.hasRemotes() ? '' : ' (NO REMOTE)'}`);
    });
    console.info('\nRemote branches:');
    getRepo()
        .remoteBranches()
        .forEach(branch => console.info(`- ${branch.gitName} (${branch.hash()})`));
    const unsyncedBranches = getRepo().unsyncedBranches();
    if (unsyncedBranches.length > 0) {
        console.info('\nUnsynched branches:');
        unsyncedBranches.forEach(pair => console.info(`- ${pair.local.gitName}`));
    }
}
program
    .option('-q, --quick', "Don't fetch")
    .option('-s, --safe', 'Exclude "develop" and "master" branches')
    .option('-r, --remoteless', 'show remoteless remote branches')
    .option('-a, --all')
    .parse(process.argv);
if (program.remoteless) {
    printRemotelessBranches();
}
else if (program.all) {
    printAllInfo();
}
else {
    program.outputHelp();
}
//# sourceMappingURL=info-cli.js.map