local workspaces = {
  {
    name = "home",
    path = "~/notes",
  },
}

if not vim.fn.isdirectory("~/notes/.git") then
  workspaces = {
    {
      name = "home",
      path = "~/notes/home",
    },
    {
      name = "work",
      path = "~/notes/work",
    },
  }
end

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local config = require("obsidian.config")
    local default_config = config.UIOpts.default()

    ---@diagnostic disable-next-line: missing-fields
    require("obsidian").setup({
      workspaces = workspaces,
      ui = vim.tbl_deep_extend("force", default_config, {
        checkboxes = {
          ["/"] = { char = "◧", hl_group = "ObsidianInProgress" },
          ["?"] = { char = "⏸", hl_group = "ObsidianWaiting" },
        },
        hl_groups = {
          ObsidianInProgress = { fg = "#EBCB8B" },
          ObsidianWaiting = { fg = "#C27D00" },
        },
      }),
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "gd", "<Cmd>ObsidianFollowLink<cr>", { buffer = true })
      end,
    })
  end,
  keys = {
    {
      "<Leader>jn",
      "<Cmd>ObsidianSearch<cr>",
      mode = "n",
    },
  },
}
