return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        library = vim.list_extend({
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          -- TODO: maybe add everything inside the lazy dir?
          vim.fn.stdpath("data") .. "/lazy/fzf-lua/lua",
          vim.fn.stdpath("data") .. "/lazy/obsidian.nvim/lua",
          vim.fn.stdpath("data") .. "/lazy/render-markdown.nvim/lua",
        }, vim.api.nvim_get_runtime_file("", true)),
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
