---@module "snacks"

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
    {
      "<leader>w/",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep word",
    },
    {
      "``",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
    -- {
    --   "<leader>gh",
    --   function()
    --     Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
    --   end,
    --   desc = "Show git history of current file",
    -- },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git log (󰀉 )",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git history of current line",
    },
    {
      "<leader>js",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Show git log",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart file picker",
    },
  },
}
