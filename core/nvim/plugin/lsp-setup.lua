-- This file is under plugin/ instead of after/plugin/
-- so the LSP servers are already configured when we reach after/plugin/lsp

-- Neodev must be setup before the Lua language server
require("neodev").setup()

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

require("lspconfig.ui.windows").default_options.border = "rounded"

-- Add border to hover floats (when pressing K)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

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

-- setup("marksman")
setup("bashls")
setup("pyright")
setup("yamlls")
setup("jsonls")
setup("html")
setup("cssls")
setup("rust_analyzer")
setup("terraformls")
setup("graphql")

require("lspconfig.configs").vtsls = require("vtsls").lspconfig

-- Find the absolute path to the local project's tsserver (to avoid using the
-- version embedded with vtsls)
local function find_local_tsserver()
  local root_dir = lspconfig.util.root_pattern("node_modules/typescript/lib")(vim.loop.cwd())
  if root_dir == nil then
    return nil
  end

  return root_dir .. "/node_modules/typescript/lib"
end

setup("vtsls", {
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
    typescript = {
      tsdk = find_local_tsserver(),
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
})
setup("denols", {
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://crux.land"] = true,
            ["https://deno.land"] = true,
            ["https://x.nest.land"] = true,
          },
          autoDiscover = true,
        },
        autoImports = true,
        names = true,
        completeFunctionCalls = true,
      },
    },
  },
})

-- Setup: TypeScript
-- require("typescript-tools").setup({
--   server = {
--     capabilities = capabilities,
--   },
--   root_dir = lspconfig.util.root_pattern("package.json"),
--   single_file_support = false,
--   on_attach = function(client)
--     -- Disable tsserver formatting (using prettier instead)
--     client.server_capabilities.document_formatting = false
--   end,
-- })
-- require("typescript").setup({
--   server = {
--     capabilities = capabilities,
--   },
--   init_options = {
--     maxTsServerMemory = 4096,
--   },
--   on_attach = function(client)
--     -- Disable tsserver formatting (using prettier instead)
--     client.server_capabilities.document_formatting = false
--   end,
-- })

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
