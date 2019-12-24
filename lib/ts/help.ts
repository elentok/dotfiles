import * as path from 'path'
import * as fs from 'fs'
import chalk from 'chalk'
import { execSync } from 'child_process'
import * as fg from 'fast-glob'

const HELP_FILENAME = path.join(process.env.DOTF || '', 'docs', 'help.md')
const LOCAL_HELP_GLOB = path.join(process.env.DOTL || '', 'docs', '*.md')

export function help(): void {
  const query = process.argv[2]

  if (query === 'e') {
    execSync(`nvim ${HELP_FILENAME}`, { stdio: 'inherit' })
  } else {
    console.info(findSections(HELP_FILENAME, query).join('\n'))

    fg.sync(LOCAL_HELP_GLOB).forEach(filename => {
      console.info(findSections(filename, query).join('\n'))
    })
  }
}

function findSections(filename: string, query?: string): string[] {
  const sections: string[] = []
  let sectionLines: string[] = []

  fs.readFileSync(filename)
    .toString()
    .split('\n')
    .forEach(line => {
      if (isBeginningOfSection(line)) {
        addSection(sections, sectionLines.join('\n'), query)
        sectionLines = [line]
      } else {
        sectionLines.push(line)
      }
    })

  addSection(sections, sectionLines.join('\n'), query)

  return sections
}

function isBeginningOfSection(line: string): boolean {
  return /^#/.test(line)
}

function addSection(sections: string[], section: string, query?: string): void {
  if (/^\s*$/.test(section)) return

  if (query == null) {
    sections.push(section)
  } else if (isMatch(section, query)) {
    sections.push(highlightQuery(section, query))
  }
}

function isMatch(section: string, query: string): boolean {
  return new RegExp(query, 'i').test(section)
}

function highlightQuery(section: string, query: string): string {
  const highlight = chalk.bold.green(query)
  return section.replace(new RegExp(query, 'ig'), highlight)
}
