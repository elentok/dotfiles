import * as program from 'commander'
import { LocalBranch } from './branch'
import { Repo } from './repo'

let repo: Repo

function getRepo() {
  if (repo == null) {
    repo = new Repo(process.cwd())
    if (program.quick == null) repo.fetchRemotes()
  }
  return repo
}

function remoteless() {
  getRepo()
    .localBranches()
    .filter(branch => !branch.hasRemotes() && isSafe(branch))
    .forEach(branch => console.info(branch.gitName))
}

function isSafe(branch: LocalBranch) {
  if (program.safe == null) return true

  return !['master', 'develop'].includes(branch.gitName)
}

function allInfo() {
  console.info('Local branches:')
  getRepo()
    .localBranches()
    .forEach(branch => {
      console.info(
        `- ${branch.gitName} (${branch.hash()})${branch.hasRemotes() ? '' : ' (NO REMOTE)'}`
      )
    })

  console.info('\nRemote branches:')
  getRepo()
    .remoteBranches()
    .forEach(branch => console.info(`- ${branch.gitName} (${branch.hash()})`))

  const unsyncedBranches = getRepo().unsyncedBranches()
  if (unsyncedBranches.length > 0) {
    console.info('\nUnsynched branches:')
    unsyncedBranches.forEach(pair => console.info(`- ${pair.local.gitName}`))
  }
}

program
  .option('-q, --quick', "Don't fetch")
  .option('-s, --safe', 'Exclude "develop" and "master" branches')
  .option('-r, --remoteless', 'show remoteless remote branches')
  .option('-a, --all')
  .parse(process.argv)

if (program.remoteless) {
  remoteless()
} else if (program.all) {
  allInfo()
} else {
  program.outputHelp()
}
