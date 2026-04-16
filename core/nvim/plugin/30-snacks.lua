---@module "snacks"

local function git_log_file()
  Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
end

local function git_log_line()
  Snacks.picker.git_log_line(require("stuff.snacks.git").git_commits_picker_config)
end

local function jump_to_config()
  Snacks.picker.files({
    dirs = { "~/.dotfiles/core/nvim", "~/.dotplugins/*/nvim" },
  })
end

local function insert_file_path()
  Snacks.picker.files({
    confirm = { action = "put", field = "file" },
  })
end

---@type snacks.picker.layout.Config
local vertical2 = {
  layout = {
    relative = "editor",
    backdrop = false,
    width = 0.8,
    height = 0.8,
    box = "vertical",
    border = "rounded",
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.6, border = "top" },
  },
}

local vertical_no_preview = {
  hidden = { "preview" },
  layout = {
    relative = "editor",
    backdrop = false,
    width = 0.5,
    min_width = 80,
    height = 0.4,
    min_height = 2,
    box = "vertical",
    border = "rounded",
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none" },
  },
}

---@type snacks.Config
require("snacks").setup({
  layout = {
    preset = "vscode",
  },

  picker = {
    layout = vertical2,
    formatters = {
      file = {
        truncate = 50,
      },
    },
    win = {
      input = {
        keys = {
          ["@"] = "qflist",
          ["<C-l>"] = { "history_forward", mode = { "i", "n" } },
          ["<C-h>"] = { "history_back", mode = { "i", "n" } },
        },
      },
    },

    sources = {
      select = {
        layout = vertical_no_preview,
      },
      smart = {
        layout = {
          preset = "vscode",
        },
      },
    },
  },

  image = {
    enabled = true,
    doc = { inline = false, float = true },
  },
  bigfile = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  indent = { enabled = true },
  scope = { enabled = true },
  lazygit = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  styles = {
    terminal = {
      border = "rounded",
    },
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
})

vim.cmd("highlight SnacksIndent guifg=#303030")

vim.keymap.set(
  "n",
  "<leader><space>",
  function() Snacks.picker.smart({ filter = { cwd = true } }) end,
  { desc = "Smart file picker" }
)
vim.keymap.set("n", "``", function() Snacks.picker.resume() end, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set(
  "n",
  "<leader>jr",
  function() Snacks.picker.recent({ filter = { cwd = true } }) end,
  { desc = "Find recent files" }
)
vim.keymap.set(
  "n",
  "<leader>jR",
  function() Snacks.picker.recent() end,
  { desc = "Find recent files" }
)
vim.keymap.set("n", "<leader>jb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set(
  "n",
  "<leader>:",
  function() Snacks.picker.command_history() end,
  { desc = "Command History" }
)
vim.keymap.set(
  "n",
  "grr",
  function() Snacks.picker.lsp_references() end,
  { desc = "LSP references" }
)
vim.keymap.set(
  "n",
  "<leader>/",
  function() Snacks.picker.grep({ root = false }) end,
  { desc = "Grep word" }
)
vim.keymap.set(
  "n",
  "<leader>w/",
  function() Snacks.picker.grep_word({ root = false }) end,
  { desc = "Grep word" }
)
vim.keymap.set(
  "v",
  "<leader>/",
  function() Snacks.picker.grep_word({ root = false }) end,
  { desc = "Grep selection" }
)
vim.keymap.set("n", "<leader>jc", jump_to_config, { desc = "Jump to config" })
vim.keymap.set(
  "n",
  "<leader>js",
  function() Snacks.picker.lsp_symbols({ filter = { typescript = true, typescriptreact = true } }) end,
  { desc = "Jump to LSP symbol" }
)
vim.keymap.set("n", "<leader>jh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>ju", function() Snacks.picker.undo() end, { desc = "Undotree" })
vim.keymap.set("n", "<leader>jk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "gre", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set(
  "n",
  "grd",
  function() Snacks.picker.diagnostics_buffer() end,
  { desc = "Buffer Diags" }
)
vim.keymap.set(
  "n",
  "<leader>ch",
  function() Snacks.picker.command_history() end,
  { desc = "Command History" }
)
vim.keymap.set(
  "n",
  "<leader>gg",
  function() Snacks.terminal({ "gx", "status" }) end,
  { desc = "gx status" }
)
vim.keymap.set("n", "<leader>gl", git_log_file, { desc = "Show git log" })
vim.keymap.set("n", "<leader>gL", git_log_line, { desc = "Show git history of current line" })
vim.keymap.set(
  "n",
  "<leader>gD",
  function() Snacks.picker.git_diff() end,
  { desc = "Git Diff (hunks)" }
)
vim.keymap.set(
  "n",
  "<leader>gs",
  function() Snacks.picker.git_status() end,
  { desc = "Git Status" }
)
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
vim.keymap.set("n", "z=", function() Snacks.picker.spelling() end, { desc = "Fix spelling" })
vim.keymap.set(
  "n",
  "<leader>nn",
  function() Snacks.notifier.show_history() end,
  { desc = "Show notifier history" }
)
vim.keymap.set(
  "i",
  "<c-x>n",
  function() Snacks.picker.icons({ icon_sources = { "nerd_fonts" } }) end,
  { desc = "Insert nerdfont icon" }
)
vim.keymap.set(
  "i",
  "<c-x>e",
  function() Snacks.picker.icons({ icon_sources = { "emoji" } }) end,
  { desc = "Insert emoji" }
)
vim.keymap.set("n", "<leader>if", insert_file_path, { desc = "Insert file path" })
