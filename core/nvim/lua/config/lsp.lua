local server_names = {
  "bashls",
  "biome",
  "cssls",
  "cssmodules_ls",
  "denols",
  "docker_compose_language_service",
  "dockerls",
  "dprint",
  "fish_lsp",
  "gopls",
  "graphql",
  -- "harper_ls",
  "html",
  "jsonls",
  -- "lua_ls",
  "marksman",
  "openscad_lsp",
  "pyright",
  "spyglassmc_language_server",
  "taplo",
  "ty",
  "vtsls",
  "yamlls",
  --
  "eslint",
}

local lsp_utils = require("elentok.lsp-utils")

for _, server_name in ipairs(server_names) do
  vim.lsp.config(server_name, { on_attach = lsp_utils.on_attach })
end

vim.lsp.enable(server_names)

require("config.lsp-luals")
