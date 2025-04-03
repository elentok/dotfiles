---@module "snacks"

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    layout = {
      preset = "vscode",
    },

    picker = {
      win = {
        input = {
          keys = {
            ["@"] = "qflist",
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
          layout = {
            preset = "sidebar",
          },
        },
      },
    },

    image = { enabled = true, markdown = { enabled = true } },
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
    {
      "<leader>gh",
      function()
        Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git history of current file",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git history of current file",
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
    {
      "<c-x><c-n>",
      function()
        Snacks.picker.icons({ icon_sources = { "nerd_fonts" } })
      end,
      mode = "i",
      desc = "Insert nerdfont icon",
    },
    {
      "<c-x>e",
      function()
        Snacks.picker.icons({ icon_sources = { "emoji" } })
      end,
      mode = "i",
      desc = "Insert emoji",
    },
  },
}
