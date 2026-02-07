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

local function on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

for _, server_name in ipairs(server_names) do
  vim.lsp.config(server_name, { on_attach = on_attach })
end

vim.lsp.enable(server_names)

vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          "${3rd}/luv/library",
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.enable("lua_ls")
