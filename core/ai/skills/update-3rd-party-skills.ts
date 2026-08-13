#!/usr/bin/env node
/**
 * Keeps a local copy of selected 3rd party skills, inlined for security and
 * ease-of-deployment. Safe to re-run: re-clones each source repo and
 * overwrites the skill directories and their README.md.
 */

import { spawnSync } from "node:child_process"
import * as fs from "node:fs"
import * as os from "node:os"
import * as path from "node:path"
import { fileURLToPath } from "node:url"

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url))

interface SkillSpec {
  sourcePath: string
  destName?: string
}

function sourceName(skill: SkillSpec): string {
  return skill.sourcePath.split("/").at(-1)!
}

function resolvedDestName(skill: SkillSpec): string {
  return skill.destName ?? sourceName(skill)
}

interface Repo {
  url: string
  skills: SkillSpec[]
}

const REPOS: Repo[] = [
  {
    url: "https://github.com/mattpocock/skills",
    skills: [
      {
        sourcePath: "skills/engineering/setup-matt-pocock-skills",
        destName: "setup-elentok-skills",
      },
      { sourcePath: "skills/engineering/codebase-design" },
      { sourcePath: "skills/engineering/code-review" },
      { sourcePath: "skills/engineering/domain-modeling" },
      { sourcePath: "skills/engineering/grill-with-docs" },
      { sourcePath: "skills/engineering/implement" },
      { sourcePath: "skills/engineering/improve-codebase-architecture" },
      { sourcePath: "skills/engineering/resolving-merge-conflicts" },
      { sourcePath: "skills/engineering/tdd" },
      { sourcePath: "skills/engineering/to-spec" },
      { sourcePath: "skills/engineering/triage" },
      { sourcePath: "skills/engineering/wayfinder" },
      { sourcePath: "skills/productivity/grill-me" },
      { sourcePath: "skills/productivity/grilling" },
      { sourcePath: "skills/productivity/handoff" },
      { sourcePath: "skills/productivity/teach" },
      { sourcePath: "skills/productivity/wait-what" },
      { sourcePath: "skills/productivity/writing-for-agents" },
    ],
  },
  {
    url: "https://github.com/cursor/plugins",
    skills: [
      { sourcePath: "cursor-team-kit/skills/thermo-nuclear-code-quality-review" },
    ],
  },
  {
    url: "https://github.com/herdrdev/herdr",
    skills: [
      { sourcePath: "skills/herdr" },
    ],
  },
]

function run(command: string, args: string[], options: { cwd?: string } = {}): void {
  const result = spawnSync(command, args, { stdio: ["ignore", "inherit", "inherit"], ...options })
  if (result.status !== 0) {
    throw new Error(`Command failed: ${command} ${args.join(" ")}`)
  }
}

function cloneRepo(repoUrl: string): string {
  const cloneDir = path.join(os.tmpdir(), repoUrl.split("/").at(-1)!)
  fs.rmSync(cloneDir, { recursive: true, force: true })
  run("git", ["clone", "--depth", "1", "--quiet", repoUrl, cloneDir])
  return cloneDir
}

function skillTitle(destName: string): string {
  return destName
    .split("-")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ")
}

function writeReadme(destDir: string, repoUrl: string, skill: SkillSpec): void {
  const destName = resolvedDestName(skill)
  const lines = [
    `# ${skillTitle(destName)}`,
    "",
    `Inlined from ${repoUrl}/blob/main/${skill.sourcePath}/SKILL.md ` +
      "for security and ease-of-deployment.",
  ]
  if (sourceName(skill) !== destName) {
    lines.push(
      "",
      `Renamed from \`${sourceName(skill)}\` to \`${destName}\` to make it easier to run.`,
    )
  }
  fs.writeFileSync(path.join(destDir, "README.md"), lines.join("\n") + "\n")
}

const PERSONALIZATIONS: Record<string, string> = {
  "matt-pocock": "elentok",
  "Matt Pocock": "David Elentok",
}

function personalizeSkill(dest: string): void {
  for (const filePath of walkFiles(dest)) {
    if (filePath === path.join(dest, "README.md")) continue

    const text = fs.readFileSync(filePath, "utf8")
    let newText = text
    for (const [oldStr, newStr] of Object.entries(PERSONALIZATIONS)) {
      newText = newText.replaceAll(oldStr, newStr)
    }

    if (newText !== text) {
      fs.writeFileSync(filePath, newText)
    }
  }
}

function* walkFiles(dir: string): Generator<string> {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const entryPath = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      yield* walkFiles(entryPath)
    } else if (entry.isFile()) {
      yield entryPath
    }
  }
}

function copySkill(cloneDir: string, repoUrl: string, skill: SkillSpec): void {
  const destName = resolvedDestName(skill)
  const src = path.join(cloneDir, skill.sourcePath)
  const dest = path.join(SCRIPT_DIR, destName)

  if (!fs.existsSync(src) || !fs.statSync(src).isDirectory()) {
    console.error(`Skipping ${destName}: ${src} not found`)
    return
  }

  fs.rmSync(dest, { recursive: true, force: true })
  fs.cpSync(src, dest, { recursive: true })
  personalizeSkill(dest)
  writeReadme(dest, repoUrl, skill)
  console.log(`Updated ${destName}`)
}

function runPrettier(): void {
  run("npx", ["--yes", "prettier", "--write", "**/*.md"], { cwd: SCRIPT_DIR })
}

function main(): void {
  for (const repo of REPOS) {
    const cloneDir = cloneRepo(repo.url)
    for (const skill of repo.skills) {
      copySkill(cloneDir, repo.url, skill)
    }
  }

  runPrettier()
}

main()
