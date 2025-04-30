return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      workspace = {
        library = vim.list_extend(
          { "${3rd}/luv/library", "${3rd}/busted/library" },
          vim.api.nvim_get_runtime_file("", true)
        ),
      },
    },
  },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
}
