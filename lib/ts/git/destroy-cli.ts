import chalk from 'chalk'
import { confirm } from '../utils'
import { LocalBranch, RemoteBranch } from './branch'
import { Repo } from './repo'

const USAGE = `
Deletes branch from local and remote

Usage:

  git destroy <branch>...

`

async function main() {
  const branches = process.argv.splice(2)

  if (branches.length === 0) {
    console.info(USAGE)
    process.exit(1)
  }

  destroy(branches)
}

async function destroy(branchNames: string[]) {
  const repo = new Repo(process.cwd())

  branchNames.forEach(async branchName => {
    console.info(chalk.blue(`* Destroying branch ${branchName}...`))
    const localBranch = repo.findLocalBranchByName(branchName)
    let remoteBranches: RemoteBranch[]
    if (localBranch == null) {
      console.info(`  No local branch named ${branchName}`)
      remoteBranches = repo.findRemoteBranchesByName(branchName)
    } else {
      if (await confirm(`Destroy local branch ${branchName}`)) {
        await destroyLocal(localBranch)
      }
      remoteBranches = localBranch.remoteBranches
    }

    if (remoteBranches == null || remoteBranches.length === 0) {
      console.info(`  No remote branches named ${branchName}`)
    } else {
      remoteBranches.forEach(async remoteBranch => {
        if (await confirm(`Destroy remote branch ${branchName}`)) {
          remoteBranch.destroy()
        }
      })
    }
  })
}

async function destroyLocal(localBranch: LocalBranch) {
  try {
    localBranch.destroy()
  } catch (err) {
    console.error(`\nError while trying to destroy local branch ${localBranch.name}`)
    if (await confirm('force')) {
      localBranch.destroy({ force: true })
    }
  }
}

main()
