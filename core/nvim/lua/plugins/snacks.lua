---@module "snacks"

local function git_log_file()
  Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
end

local function git_log_line()
  Snacks.picker.git_log_line(require("stuff.snacks.git").git_commits_picker_config)
end

-- local function jump_to_config()
--   Snacks.picker.files({
--     dirs = { "~/.dotfiles/core/nvim", "~/.dotplugins/*/nvim" },
--   })
-- end

local header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
 ]]

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

---@type LazySpec
return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
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
    -- dashboard = { enabled = true, preset = {
    --   header = header,
    -- } },
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
    -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart file picker" },
    -- { "``", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },

    -- {
    --   "<leader>jr",
    --   function() Snacks.picker.recent({ filter = { cwd = true } }) end,
    --   desc = "Find recent files",
    -- },
    -- { "<leader>jR", function() Snacks.picker.recent() end, desc = "Find recent files" },
    -- { "<leader>jb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },

    -- LSP
    -- { "grr", function() Snacks.picker.lsp_references() end, desc = "LSP references" },

    -- Grep
    -- { "<leader>/", function() Snacks.picker.grep({ root = false }) end, desc = "Grep word" },
    -- { "<leader>w/", function() Snacks.picker.grep_word({ root = false }) end, desc = "Grep word" },
    -- {
    --   "<leader>/",
    --   function() Snacks.picker.grep_word({ root = false }) end,
    --   mode = "v",
    --   desc = "Grep selection",
    -- },

    -- Jump to
    -- { "<leader>jc", jump_to_config, desc = "Jump to config" },
    -- {
    --   "<leader>js",
    --   function()
    --     Snacks.picker.lsp_symbols({ filter = { typescript = true, typescriptreact = true } })
    --   end,
    --   desc = "Jump to LSP symbol",
    -- },
    -- { "<leader>jh", function() Snacks.picker.help() end, desc = "Help Pages" },
    -- { "<leader>ju", function() Snacks.picker.undo() end, desc = "Undotree" },
    -- { "<leader>jk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    -- { "gre", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    -- { "grd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diags" },
    -- { "<leader>ch", function() Snacks.picker.command_history() end, desc = "Command History" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    -- { "<leader>gl", git_log_file, desc = "Show git log" },
    -- { "<leader>gL", git_log_line, desc = "Show git history of current line" },
    -- { "<leader>gD", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
    -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },

    -- Actions
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },

    -- Notifier
    { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Show notifier history" },

    -- Icons
    {
      "<c-x>n",
      function() Snacks.picker.icons({ icon_sources = { "nerd_fonts" } }) end,
      mode = "i",
      desc = "Insert nerdfont icon",
    },
    {
      "<c-x>e",
      function() Snacks.picker.icons({ icon_sources = { "emoji" } }) end,
      mode = "i",
      desc = "Insert emoji",
    },
  },
  init = function() vim.cmd("highlight SnacksIndent guifg=#303030") end,
}
