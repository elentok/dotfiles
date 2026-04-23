local servers = {
  bashls = { "bash", "sh" },
  biome = {
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
  cssls = { "css", "scss", "less" },
  cssmodules_ls = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  denols = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  docker_compose_language_service = { "yaml.docker-compose" },
  dockerls = { "dockerfile" },
  dprint = { "markdown" },
  eslint = {
    "astro",
    "htmlangular",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  fish_lsp = { "fish" },
  gopls = { "go", "gomod", "gowork", "gotmpl" },
  graphql = { "graphql", "typescriptreact", "javascriptreact" },
  html = { "html", "templ" },
  jsonls = { "json", "jsonc" },
  ["markdown-oxide"] = { "markdown" },
  openscad_lsp = { "openscad" },
  spyglassmc_language_server = { "mcfunction" },
  taplo = { "toml" },
  ty = { "python" },
  vtsls = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  yamlls = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
}

local configured = {}

local function configure_server(server_name)
  if configured[server_name] then return end
  configured[server_name] = true

  local lsp_utils = require("elentok.lsp-utils")

  if server_name == "jsonls" then
    vim.lsp.config("jsonls", {
      on_attach = function(client, bufnr)
        -- When biome is used, disable jsonls's formatting
        if require("elentok.utils").hasfile({ "biome.json", "biome.jsonc" }) then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        lsp_utils.on_attach(client, bufnr)
      end,
    })
  else
    vim.lsp.config(server_name, { on_attach = lsp_utils.on_attach })
  end

  vim.lsp.enable(server_name)
end

local servers_by_filetype = {}
for server_name, filetypes in pairs(servers) do
  for _, filetype in ipairs(filetypes) do
    servers_by_filetype[filetype] = servers_by_filetype[filetype] or {}
    table.insert(servers_by_filetype[filetype], server_name)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    for _, server_name in ipairs(servers_by_filetype[ev.match] or {}) do
      configure_server(server_name)
    end
    if ev.match == "lua" then require("config.lsp-luals") end
  end,
})
