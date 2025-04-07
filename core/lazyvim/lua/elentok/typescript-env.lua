---@type 'deno' | 'node'
local mode = "node"

---@type string[]
local formatter = { "prettierd" }

if vim.fn.findfile("deno.jsonc", ".;") ~= "" or vim.fn.findfile("deno.json", ".;") ~= "" then
  vim.notify("Found deno.json file")
  mode = "deno"
  formatter = {} -- fallback to LSP
end

return { mode = mode, formatter = formatter }
