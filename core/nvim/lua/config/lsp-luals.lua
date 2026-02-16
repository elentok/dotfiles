local function get_library_paths()
  local paths = {}
  local lazy_root = vim.fn.stdpath("data") .. "/lazy"
  for name, type in vim.fs.dir(lazy_root) do
    local lua_path = string.format("%s/%s/lua", lazy_root, name)
    if type == "directory" then table.insert(paths, lua_path) end
  end

  vim.list_extend(paths, {
    vim.env.VIMRUNTIME,
    "${3rd}/luv/library",
  })

  return paths
end

vim.lsp.config("lua_ls", {
  on_attach = require("elentok.lsp-utils").on_attach,
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
        library = get_library_paths(),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.enable("lua_ls")
