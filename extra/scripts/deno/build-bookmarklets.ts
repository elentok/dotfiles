#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run --allow-write

import * as path from "jsr:@std/path"
import { minify } from "https://esm.sh/terser@5.36.0"

const HEADER = `<!DOCTYPE html>
<html>
<head>
  <title>Bookmarklets</title>
  <style>
    body { background: #242424; color: #ccc; font-family: sans-serif; }
    a { color: #ccc; display: inline-block; padding: 5px 10px; }
    a:hover { background-color: #343434; }
  </style>
</head>
<body>
<ul> 
`

const FOOTER = `</ul></body>
</html>
`

let dirname = Deno.cwd()
if (Deno.args.length > 0) {
  dirname = Deno.args[0]
}

const outputFilename = path.join(dirname, "bookmarklets.html")
const contents = [HEADER]

for (const file of Deno.readDirSync(dirname)) {
  if (!/\.js/.test(file.name)) continue

  console.info(`Building ${file.name}...`)

  const source = Deno.readTextFileSync(path.join(dirname, file.name))
  const result = await minify(source)
  if (result.error != null) {
    console.error("Build failed: ", result.error)
  } else {
    contents.push(
      `  <li><a href="javascript:${
        encodeURIComponent(result.code)
      }">${file.name}</a></li>`,
    )
  }
}

contents.push(FOOTER)

Deno.writeTextFileSync(outputFilename, contents.join("\n"))
