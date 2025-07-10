---@diagnostic disable: missing-fields
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ---@module 'obsidian'
  ---@type obsidian.config.ClientOpts
  opts = {
    new_notes_location = "current_dir",
    completion = {
      blink = true,
    },
    picker = {
      name = "snacks.pick",
    },
    disable_frontmatter = true,
    workspaces = {
      {
        name = "notes",
        path = "~/notes",
      },
    },
    ui = {
      -- Using render-markdown instead
      enable = false,
      checkboxes = {
        [" "] = {},
        ["x"] = {},
        ["/"] = {},
        ["w"] = {},
        ["r"] = {},
      },
    },
  },
}
