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

---@type snacks.picker.layout.Config
local vertical2 = {
  layout = {
    relative = "editor",
    backdrop = false,
    width = 0.8,
    min_width = 80,
    height = 0.8,
    min_height = 30,
    box = "vertical",
    border = "rounded",
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.6, border = "top" },
  },
}

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    layout = {
      preset = "vscode",
    },

    picker = {
      formatters = {
        file = {
          truncate = 50,
        },
      },
      win = {
        input = {
          keys = {
            ["@"] = "qflist",
            ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-p>"] = { "history_back", mode = { "i", "n" } },
          },
        },
      },

      sources = {
        smart = {
          layout = {
            preset = "vscode",
          },
        },
        git_diff = {
          layout = vertical2,
        },
        git_log = {
          layout = vertical2,
        },
        git_log_line = {
          layout = vertical2,
        },
        git_log_file = {
          layout = vertical2,
        },
        lsp_references = {
          layout = vertical2,
        },
        lsp_definitions = {
          layout = vertical2,
        },
      },
    },

    image = { enabled = true, markdown = { enabled = true } },
    dashboard = { enabled = true },
    bigfile = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    indent = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
  },
  styles = {
    terminal = {
      border = "rounded",
    },
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart file picker" },
    { "``", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },

    { "<leader>jr", function() Snacks.picker.recent() end, desc = "Find recent files" },
    { "<leader>jb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },

    -- LSP
    { "grr", function() Snacks.picker.lsp_references() end, desc = "LSP references" },

    -- Grep
    { "<leader>/", function() Snacks.picker.grep({ root = false }) end, desc = "Grep word" },
    { "<leader>w/", function() Snacks.picker.grep_word({ root = false }) end, desc = "Grep word" },

    -- Jump to
    { "<leader>jc", jump_to_config, desc = "Jump to config" },
    { "<leader>js", function() Snacks.picker.lsp_symbols() end, desc = "Show git log" },
    { "<leader>jh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>ju", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>jk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>jda", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>jdb", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diags" },
    { "<leader>ch", function() Snacks.picker.command_history() end, desc = "Command History" },

    -- Git
    { "<leader>gl", git_log_file, desc = "Show git log" },
    { "<leader>gL", git_log_line, desc = "Show git history of current line" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },

    -- Actions
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },

    -- Notifier
    { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Show notifier history" },
  },
}
