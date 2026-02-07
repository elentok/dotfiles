-- Set the filetype of "*docker-compose.yml" files to "yaml.docker-compose"
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*docker-compose.yml",
  callback = function() vim.bo.filetype = "yaml.docker-compose" end,
})

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
  "lua_ls",
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

local function on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

for _, server_name in ipairs(server_names) do
  vim.lsp.config(server_name, { on_attach = on_attach })
end

vim.lsp.enable(server_names)
