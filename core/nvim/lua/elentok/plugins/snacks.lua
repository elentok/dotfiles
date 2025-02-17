---@module "snacks"

---@type snacks.picker.Config
local git_picker_config = {
  actions = {
    fixup = function(picker, item)
      picker:close()
      require("elentok.lib.git-actions").fixup(item.commit, item.msg)
    end,
    open_commit = function(picker, item)
      picker:close()
      require("diffview").open(item.commit)
      -- require("diffview").open(item.commit .. "^!")
    end,
    yank_hash = function(_, item)
      vim.fn.setreg("+", item.commit)
      Snacks.notifier.notify("Copied " .. item.commit)
    end,
  },

  win = {
    input = {
      keys = {
        ["f"] = { "fixup", mode = { "n" } },
        ["<cr>"] = { "open_commit", mode = { "n", "i" } },
        ["y"] = { "yank_hash", mode = { "n", "i" } },
      },
    },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["@"] = "qflist",
          },
        },
      },
    },
    -- picker = { enabled = true, layout = { preset = "dropdown" } },
    quickfile = { enabled = true },
    image = { enabled = true, markdown = { enabled = true } },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    -- styles = {
    --   notification = {
    --     -- wo = { wrap = true } -- Wrap notifications
    --   },
    -- },
  },
  keys = {
    {
      "<leader>f",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>jb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Jump to buffer",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      mode = { "n", "v" },
      desc = "Grep",
    },
    {
      "<leader>w/",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep word",
    },
    {
      "<leader>jh",
      function()
        Snacks.picker.help()
      end,
      desc = "Jump to help",
    },
    {
      "<leader>ll",
      function()
        Snacks.picker.lines()
      end,
      desc = "Jump to keymap",
    },
    {
      "z=",
      function()
        Snacks.picker.spelling()
      end,
      desc = "Jump to keymap",
    },
    {
      "<leader>jj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jump to keymap",
    },
    {
      "<leader>jk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Jump to keymap",
    },
    {
      "<leader>jr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Jump to recent file",
    },
    {
      "<leader>jm",
      function()
        Snacks.picker.recent()
      end,
      desc = "Jump to recent file",
    },
    {
      "<leader>jg",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Show git status",
    },
    {
      "<leader>gh",
      function()
        Snacks.picker.git_log_file(git_picker_config)
      end,
      desc = "Show git history of current file",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log(git_picker_config)
      end,
      desc = "Show git log",
    },
    {
      "``",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
  },
}
