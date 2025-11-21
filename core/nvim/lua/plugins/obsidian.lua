return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = {
      enable = false,
    },
    legacy_commands = false,
    workspaces = {
      {
        name = "notes",
        path = "~/notes",
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y/%m/%Y-%m-%d",
    },
    frontmatter = {
      enabled = false,
    },
    completion = {
      blink = true,
      create_new = false,
    },
    -- wiki_link_func = "prepend*note_id",
    wiki_link_func = function(opts) return require("obsidian.util").wiki_link_id_prefix(opts) end,
    picker = {
      name = "snacks.pick",
      -- name = "fzf-lua",
    },
    checkbox = {
      order = { " ", "x", "/", "w", "r" },
    },
    disable_frontmatter = true,
    new_notes_location = "current_dir",
    note_id_func = function(title)
      local clean_title = nil
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        clean_title = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      end

      if clean_title == nil then return tostring(os.time()) end

      return clean_title
    end,
  },
  cmd = {
    "Obsidian",
  },
  keys = {
    { "<leader>ob", ":Obsidian<cr>", desc = "Obsidian menu" },
  },
}
