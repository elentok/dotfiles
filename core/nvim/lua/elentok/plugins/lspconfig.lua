return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "yioneko/nvim-vtsls",
  },

  config = function()
    local lspconfig = require("lspconfig")

    require("lspconfig.configs").vtsls = require("vtsls").lspconfig

    require("lspconfig.ui.windows").default_options.border = "rounded"
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    local capabilities =
      require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local function setup(name, opts)
      local merged_opts = vim.tbl_extend("force", {
        capabilities = capabilities,
      }, opts or {})

      lspconfig[name].setup(merged_opts)
    end

    setup("bashls")
    setup("pyright")
    setup("yamlls")
    setup("jsonls")
    setup("html")
    setup("cssls")
    setup("rust_analyzer")
    setup("terraformls")
    setup("graphql")
    setup("ruff")

    -- Find the absolute path to the local project's tsserver (to avoid using the
    -- version embedded with vtsls)
    local function find_local_tsserver()
      local root_dir = lspconfig.util.root_pattern("node_modules/typescript/lib")(vim.uv.cwd())
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
          inlayHints = true,
        },
        typescript = {
          tsdk = find_local_tsserver(),
          tsserver = {
            maxTsServerMemory = 12288,
            useSeparateSyntaxServer = false,
            useSyntaxServer = "never",
          },
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

    setup("openscad_lsp", {
      cmd = { "openscad-lsp", "--stdio", "--fmt-style", "Google" },
    })
  end,
}
