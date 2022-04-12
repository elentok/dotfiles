local lsp = require("elentok/lsp")

local root_path = vim.fn.expand("~/.apps/all/lua-language-server/default")

local bin_paths = {
  root_path .. "/bin/Linux/lua-language-server",
  root_path .. "/bin/lua-language-server"
}

local bin_path
for _, path in pairs(bin_paths) do
  if vim.fn.filereadable(path) ~= 0 then
    bin_path = path
    break
  end
end

local main_lua = root_path .. "/main.lua"

lsp.setup({
  sumneko_lua = {
    cmd = {bin_path, "-E", main_lua},
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
