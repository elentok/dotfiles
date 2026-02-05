-- Set the filetype of "*docker-compose.yml" files to "yaml.docker-compose"
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*docker-compose.yml",
  callback = function() vim.bo.filetype = "yaml.docker-compose" end,
})

vim.lsp.enable({
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
})
