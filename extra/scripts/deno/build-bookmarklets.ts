#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run --allow-write

import * as path from "node:path"
import * as fs from "node:fs"
import UglifyES from "npm:uglify-es"

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
const stream = fs.createWriteStream(outputFilename)
stream.write(HEADER)

fs.readdirSync(dirname).forEach((file) => {
  if (!/\.js/.test(file)) return

  console.info(`Building ${file}...`)

  const source = fs.readFileSync(path.join(dirname, file)).toString()
  const result = UglifyES.minify(source)
  if (result.error != null) {
    console.error("Build failed: ", result.error)
  } else {
    stream.write(
      `  <li><a href="javascript:${escape(result.code)}">${file}</a></li>\n`,
    )
  }
})

stream.end(FOOTER)
