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

function prettifyFilename(filename: string): string {
  const baseName = filename.replace(/\.[^/.]+$/, "") // Remove extension
  const words = baseName.split("-").map((word) => word.toLowerCase())
  if (words.length === 0) return ""
  words[0] = words[0].charAt(0).toUpperCase() + words[0].slice(1)
  return words.join(" ")
}

function getTitle(source: string, filename: string): string {
  // Check if the first line matches the title pattern
  const firstLine = source.split("\n")[0].trim()
  const titleMatch = firstLine.match(/^\/\/\s*title:\s*(.+)$/i)

  if (titleMatch) {
    return titleMatch[1].trim()
  }

  // Prettify the filename if no title was found
  return prettifyFilename(filename)
}

for (const file of Deno.readDirSync(dirname)) {
  if (!/\.js/.test(file.name)) continue

  console.info(`Building ${file.name}...`)

  const source = Deno.readTextFileSync(path.join(dirname, file.name))
  const result = await minify(source)
  if (result.error != null) {
    console.error("Build failed: ", result.error)
  } else {
    contents.push(
      `  <li><a href="javascript:${encodeURIComponent(result.code)}">${
        getTitle(source, file.name)
      }</a></li>`,
    )
  }
}

contents.push(FOOTER)

Deno.writeTextFileSync(outputFilename, contents.join("\n"))
