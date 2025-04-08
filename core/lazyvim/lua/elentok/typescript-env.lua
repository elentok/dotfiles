---@type 'deno' | 'node'
local mode = "node"

---@type string[]
local formatter = { "prettierd" }

---@type string[]
local linters = {}

if vim.fn.findfile("deno.jsonc", ".;") ~= "" or vim.fn.findfile("deno.json", ".;") ~= "" then
  vim.notify("Found deno.json file")
  mode = "deno"
  formatter = {} -- fallback to LSP
elseif vim.fn.findfile("eslint.config.js", ";.") ~= "" or vim.fn.findfile(".eslintrc.js", ";.") ~= "" then
  vim.notify("Found eslint config file")
  linters = { "eslint_d" }
end

return { mode = mode, formatter = formatter, linters = linters }
