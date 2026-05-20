require("fzf-lua").setup({
  winopts = {
    border = "rounded",
    preview = {
      layout = "vertical",
    },
  },

  keymap = {
    fzf = {
      -- sends everything to the quickfix list
      ["ctrl-q"] = "select-all+accept",
    },
  },
})

local set = vim.keymap.set

set("n", "<leader><space>", ":FzfLua files<cr>", { desc = "Smart file picker" })
set("n", "<leader>jb", ":FzfLua buffers<cr>", { desc = "Buffers" })
set("n", "<leader>jh", ":FzfLua helptags<cr>", { desc = "Help tags" })
set("n", "<leader>gs", ":FzfLua git_status<cr>", { desc = "Git status" })
set("n", "<leader>/", ":FzfLua live_grep multiline=true<cr>", { desc = "Grep word" })
set("n", "<leader>jr", ":FzfLua oldfiles cwd_only=true<cr>", { desc = "Jump to recent file" })

set("n", "``", ":FzfLua resume<cr>", { desc = "Resume last picker" })
set("n", "<leader>ff", ":FzfLua files<cr>", { desc = "Find Files" })

set("n", "grr", ":FzfLua lsp_references multiline=true<cr>", { desc = "LSP references" })
set("n", "gd", ":FzfLua lsp_defintions<cr>", { desc = "LSP definition" })
