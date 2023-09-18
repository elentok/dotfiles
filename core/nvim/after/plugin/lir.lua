local lir = require("lir")
local actions = require("lir.actions")
local mark_actions = require("lir.mark.actions")
local clipboard_actions = require("lir.clipboard.actions")
local float = require("lir.float")

lir.setup({
  devicons = {
    enable = true,
  },
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
      mark_actions.toggle_mark("n")
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

local function go_up_in_window()
  if vim.api.nvim_buf_get_option(0, "filetype") == "lir" then
    vim.cmd.normal("-")
  else
    vim.cmd.edit(vim.fn.expand("%:p:h"))
  end
end

-- vim.keymap.set("n", "-", go_up, { desc = "Go up (float)" })
vim.keymap.set("n", "<space>-", go_up_in_window, { desc = "Go up" })

local group = vim.api.nvim_create_augroup("Elentok_Lir", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lir" },
  group = group,
  callback = function()
    vim.wo.spell = false
  end,
})

vim.api.nvim_create_user_command("E", ":e <args>", { nargs = "*" })
