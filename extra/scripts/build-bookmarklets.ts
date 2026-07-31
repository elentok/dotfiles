#!/usr/bin/env node

import * as fs from "node:fs"
import * as path from "node:path"
import { minify } from "terser"

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

const args = process.argv.slice(2)
let dirname = process.cwd()
if (args.length > 0) {
  dirname = args[0]
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

for (const file of fs.readdirSync(dirname)) {
  if (!/\.js/.test(file)) continue

  console.info(`Building ${file}...`)

  const source = fs.readFileSync(path.join(dirname, file), "utf8")
  const result = await minify(source)
  if (result.code == null) {
    console.error("Build failed: ", result)
  } else {
    contents.push(
      `  <li><a href="javascript:${encodeURIComponent(result.code)}">${
        getTitle(source, file)
      }</a></li>`,
    )
  }
}

contents.push(FOOTER)

fs.writeFileSync(outputFilename, contents.join("\n"))
