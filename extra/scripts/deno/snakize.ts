#!/usr/bin/env -S deno run --allow-env --allow-write --allow-read --allow-run

function main() {
  const noop = !Deno.args.includes("-r")

  if (noop) {
    console.info()
    console.info('Simulating rename, to actually rename run with "-r"')
    console.info()
  }

  for (const filename of Deno.readDirSync(".")) {
    const newName = snakize(filename.name)
    if (newName === filename.name) continue

    console.info(`Renaming "${filename.name}" to "${newName}"`)
    if (!noop) {
      Deno.renameSync(filename.name, newName)
    }
  }
}

function snakize(name: string): string {
  return name.replace(/^([A-Z])/, (match) => match.toLowerCase())
    .replace(/[_-]?([A-Z])/g, (_match, char) => `-${char.toLowerCase()}`)
}

main()
