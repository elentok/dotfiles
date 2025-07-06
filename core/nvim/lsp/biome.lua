local utils = require("elentok.utils")

vim.g.biome_cmd = "biome"
local config_file = utils.findfiles({ "biome.json", "biome.jsonc" })
if config_file ~= "" then
  local local_biome = vim.fs.dirname(config_file) .. "/node_modules/@biomejs/biome/bin/biome"
  if vim.uv.fs_stat(local_biome) then vim.g.biome_cmd = "node " .. local_biome end
end

return {
  cmd = { vim.g.biome_cmd, "lsp-proxy" },
  filetypes = {
    "astro",
    "css",
    "graphql",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  workspace_required = true,
  root_markers = { "biome.json", "biome.jsonc" },
}
