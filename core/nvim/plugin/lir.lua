local actions = require "lir.actions"
local mark_actions = require "lir.mark.actions"
local clipboard_actions = require "lir.clipboard.actions"
local float = require "lir.float"
local map = require "elentok/map"

require("lir").setup({

  devicons_enable = true,
  mappings = {
    ["<cr>"] = actions.edit,
    ["l"] = actions.edit,
    ["h"] = actions.up,
    ["-"] = actions.up,
    ["q"] = actions.quit,

    ["o"] = actions.mkdir,
    ["i"] = actions.newfile,
    ["r"] = actions.rename,
    ["@"] = actions.cd,
    ["Y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["D"] = actions.delete,

    ["J"] = function()
      mark_actions.toggle_mark()
      vim.cmd("normal! j")
    end,
    ["C"] = clipboard_actions.copy,
    ["X"] = clipboard_actions.cut,
    ["P"] = clipboard_actions.paste
  },

  float = {
    winblend = 0,
    curdir_window = {enable = true, highlight_dirname = true}
  }

})

function _G.Elentok_GoUp()
  float.init()
end

map.normal("-", map.lua("Elentok_GoUp()"))
