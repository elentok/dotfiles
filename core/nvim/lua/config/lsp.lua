local configured = {}
local defaults_configured = false

local function configure_defaults()
  if defaults_configured then return end
  defaults_configured = true

  vim.lsp.config("*", {
    on_attach = require("elentok.lsp-utils").on_attach,
  })
end

---@param server_name string
---@param config? vim.lsp.Config
local function configure_server(server_name, config)
  if configured[server_name] then return end
  configured[server_name] = true

  configure_defaults()
  if config then vim.lsp.config(server_name, config) end
  vim.lsp.enable(server_name)
end

---@param name string
---@param filetypes string[]
---@param config? vim.lsp.Config
local function add_server(name, filetypes, config)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function() configure_server(name, config) end,
  })
end

local js_ts_filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

add_server("bashls", { "bash", "sh" })
add_server("biome", {
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
})
add_server("cssls", { "css", "scss" })
add_server("css_variables", { "css", "scss" })
add_server("cssmodules_ls", { "javascript", "javascriptreact", "typescript", "typescriptreact" })
add_server("denols", js_ts_filetypes)
add_server("docker_compose_language_service", { "yaml.docker-compose" })
add_server("dockerls", { "dockerfile" })
add_server("dprint", { "markdown" })
add_server("eslint", {
  "astro",
  "htmlangular",
  "javascript",
  "javascriptreact",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
})
add_server("fish_lsp", { "fish" })
add_server("gopls", { "go", "gomod", "gowork", "gotmpl" })
add_server("graphql", { "graphql", "typescriptreact", "javascriptreact" })
add_server("html", { "html", "templ" })
add_server("jsonls", { "json", "jsonc" })
add_server("lua_ls", { "lua" })
add_server("markdown-oxide", { "markdown" })
add_server("openscad_lsp", { "openscad" })
add_server("pyrefly", { "python" })
add_server("spyglassmc_language_server", { "mcfunction" })
add_server("taplo", { "toml" })
add_server("vtsls", js_ts_filetypes)
add_server("yamlls", { "yaml", "yaml.docker-compose", "yaml.gitlab" })
