require("fzf-lua").setup({
  formatter = "path.filename_first",
  files = {
    formatter = "path.filename_first",
  },
  buffers = {
    formatter = "path.filename_first",
  },
  oldfiles = {
    formatter = "path.filename_first",
  },
  winopts = {
    border = "rounded",
    ---@diagnostic disable-next-line: missing-fields
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

set("n", "<leader><space>", function() FzfLua.files() end, { desc = "Smart file picker" })
set("n", "<leader>jb", function() FzfLua.buffers() end, { desc = "Buffers" })
set("n", "<leader>jh", function() FzfLua.helptags() end, { desc = "Help tags" })
set("n", "<leader>js", function() FzfLua.lsp_document_symbols() end, { desc = "Help tags" })
set("n", "<leader>gs", function() FzfLua.git_status() end, { desc = "Git status" })
set("n", "<leader>gl", function() FzfLua.git_bcommits() end, { desc = "Commits of current buffer" })
set("n", "<leader>/", function() FzfLua.live_grep({ multiline = true }) end, { desc = "Grep word" })
set(
  "n",
  "<leader>w/",
  function() FzfLua.grep_cword({ multiline = true }) end,
  { desc = "Grep word" }
)
set(
  "n",
  "<leader>jr",
  function() FzfLua.oldfiles({ cwd_only = true }) end,
  { desc = "Jump to recent file" }
)
set(
  "n",
  "<leader>jc",
  function() FzfLua.files({ cwd = "~/.dotfiles/core/nvim" }) end,
  { desc = "Jump to config" }
)

set("n", "<leader>ch", function() FzfLua.command_history() end, { desc = "Jump to config" })
set("n", "z=", function() FzfLua.spell_suggest() end, { desc = "Jump to config" })

-- FzfLua.files({ cmd = "fd --type f . ~/.dotfiles/core/nvim ~/.dotplugins/*/nvim" })

set("n", "``", function() FzfLua.resume() end, { desc = "Resume last picker" })
set("n", "<leader>ff", function() FzfLua.files() end, { desc = "Find Files" })

set(
  "n",
  "grr",
  function() FzfLua.lsp_references({ multiline = true }) end,
  { desc = "LSP references" }
)

set("n", "gre", function() FzfLua.diagnostics_workspace() end, { desc = "Workspace diagnostics" })
set("n", "grd", function() FzfLua.diagnostics_document() end, { desc = "Buffer diagnostics" })

set(
  "n",
  "gd",
  function() FzfLua.lsp_definitions({ multiline = true }) end,
  { desc = "LSP definition" }
)

set("i", "<c-x>l", function() FzfLua.complete_line() end, { desc = "Complete line" })
set("i", "<c-x><c-l>", function() FzfLua.complete_line() end, { desc = "Complete line" })
set("i", "<c-x>p", function() FzfLua.complete_path() end, { desc = "Complete path" })
set("i", "<c-x><c-p>", function() FzfLua.complete_path() end, { desc = "Complete path" })
