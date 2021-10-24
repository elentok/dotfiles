local lsp = require("elentok/lsp")

local lua_lsp_root_path = vim.fn.expand(
                              "~/.apps/all/lua-language-server/default")
local lua_lsp_bin_path = lua_lsp_root_path .. "/bin/Linux/lua-language-server"
local lua_lsp_main_lua = lua_lsp_root_path .. "/main.lua"

lsp.setup({
  sumneko_lua = {
    cmd = {lua_lsp_bin_path, "-E", lua_lsp_main_lua},
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";")
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {"vim", "use"}
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    }
  }
})
