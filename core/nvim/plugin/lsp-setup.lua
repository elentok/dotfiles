-- This file is under plugin/ instead of after/plugin/
-- so the LSP servers are already configured when we reach after/plugin/lsp

-- Neodev must be setup before the Lua language server
require("neodev").setup()

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Add border to hover floats (when pressing K)
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "rounded",
-- })

-- Setup capabilities
local capabilities = vim.tbl_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  cmp_nvim_lsp.default_capabilities()
)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup: simple
local function setup(name, opts)
  local merged_opts = vim.tbl_extend("force", {
    capabilities = capabilities,
  }, opts or {})

  lspconfig[name].setup(merged_opts)
end

setup("marksman")
setup("bashls")
setup("pyright")
setup("yamlls")
setup("jsonls")
setup("html")
setup("cssls")
setup("rust_analyzer")
setup("svelte")
setup("terraformls")
setup("graphql")

-- Setup: TypeScript
require("typescript").setup({
  server = {
    capabilities = capabilities,
  },
  init_options = {
    maxTsServerMemory = 4096,
  },
  on_attach = function(client)
    -- Disable tsserver formatting (using prettier instead)
    client.server_capabilities.document_formatting = false
  end,
})

-- Setup: Lua
local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")
setup("lua_ls", {
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = lua_runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
      },
    },
  },
})

-- Setup: OpenSCAD
setup("openscad_lsp", {
  cmd = { "openscad-lsp", "--stdio", "--fmt-style", "Google" },
  -- Disabling the OpenSCAD LSP's completion because it's very very slow
  -- on_attach = function(client)
  --   client.server_capabilities.completionProvider = false
  -- end,
})
