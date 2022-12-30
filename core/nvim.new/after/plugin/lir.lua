local lir = require("lir")
local actions = require("lir.actions")
local mark_actions = require("lir.mark.actions")
local clipboard_actions = require("lir.clipboard.actions")
local float = require("lir.float")

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
    ["cw"] = actions.rename,
    ["@"] = actions.cd,
    ["Y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["dd"] = actions.delete,
    ["D"] = actions.delete,

    ["J"] = function()
      mark_actions.toggle_mark()
      vim.cmd("normal! j")
    end,
    ["C"] = clipboard_actions.copy,
    ["X"] = clipboard_actions.cut,
    ["P"] = clipboard_actions.paste,
  },
  float = {
    winblend = 0,
    curdir_window = { enable = true, highlight_dirname = true },
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.7)
      local height = math.floor(vim.o.lines * 0.7)
      return {
        border = {
          "╭",
          "─",
          "╮",
          "│",
          "╯",
          "─",
          "╰",
          "│",
        },
        width = width,
        height = height,
      }
    end,
  },
})

local function go_up()
  float.init()
end

vim.keymap.set("n", "-", go_up)
