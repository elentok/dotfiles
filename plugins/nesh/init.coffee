fs = require 'fs'

try
  coffeescript = require 'coffee-script'
  C = (code) ->
    console.log coffeescript.compile(code, bare: true)
catch e
  console.error "Cannot load coffee-script", e

if fs.existsSync('./.nesh.coffee')
  code = fs.readFileSync('./.nesh.coffee').toString()
  coffeescript.eval(code)
