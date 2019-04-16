import * as program from 'commander'
import { findRenameables } from './renameable'
import { confirm } from './utils'

function main() {
  program
    .arguments('<pattern> <replacement> <file...>')
    .option('-y, --yes', "Don't ask for confirmation")
    .action(async (pattern: string, replacement: string, files: string[], args: IArgs) => {
      const renameables = findRenameables(pattern, replacement, files)
      if (renameables.length === 0) {
        console.info('No files to rename')
        return
      }

      renameables.forEach(r => r.print('   '))

      if (args.yes || (await confirm('Rename?'))) {
        renameables.forEach(r => {
          r.print('Renaming ')
          r.rename()
        })
      }
    })

  program.parse(process.argv)
}

interface IArgs {
  yes?: boolean
}

main()
