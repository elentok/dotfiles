#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { join } from "https://deno.land/std@0.204.0/path/mod.ts"

const home = Deno.env.get("HOME")
if (home == null) throw new Error("No HOME env variable found")

const CONFIG_FILES: string[] = [
  join(home, ".dotfiles", "config", "repos.cfg"),
  join(home, ".dotlocal", "config", "repos.cfg"),
  join(home, ".dotprivate", "config", "repos.cfg"),
  join(home, ".config", "dotfiles", "repos.cfg"),
]

function fileExistsSync(filename: string): boolean {
  try {
    return Deno.statSync(filename).isFile
  } catch (_) {
    return false
  }
}

interface Repo {
  remoteUrl: string
  localPath: string
}

function loadRepos(): Repo[] {
  return CONFIG_FILES.filter(fileExistsSync).map(loadReposFromConfigFile).flat()
}

function loadReposFromConfigFile(configFile: string): Repo[] {
  return Deno.readTextFileSync(configFile)
    .split("\n")
    .filter((line) => line.charAt(0) !== "#" && !/^\s*$/.test(line))
    .map((line) => {
      const [remoteUrl, localPath] = line.split(/\s+=\s+/)
      return { remoteUrl, localPath }
    })
}

console.log(loadRepos())
