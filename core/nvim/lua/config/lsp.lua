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
  lua_ls = { "lua" },
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
local defaults_configured = false

local function configure_defaults()
  if defaults_configured then return end
  defaults_configured = true

  vim.lsp.config("*", {
    on_attach = require("elentok.lsp-utils").on_attach,
  })
end

local function configure_server(server_name)
  if configured[server_name] then return end
  configured[server_name] = true

  configure_defaults()
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
  end,
})
