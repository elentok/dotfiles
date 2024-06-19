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
    local obsidian_config = require("obsidian.config")
    local default_config = obsidian_config.UIOpts.default()

    local ui_config = vim.tbl_deep_extend("force", default_config, {
      hl_groups = {
        ObsidianInProgress = { fg = "#EBCB8B" },
        ObsidianWaiting = { fg = "#C27D00" },
        ObsidianDone = { fg = "#6C7A96", bold = false },
      },
    })

    -- Override the default checkboxes (I only want these)
    ui_config.checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["/"] = { char = "◧", hl_group = "ObsidianInProgress" },
      ["w"] = { char = "⏸", hl_group = "ObsidianWaiting" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
    }

    local mappings = require("obsidian.mappings")

    require("obsidian").setup({
      workspaces = workspaces,
      ui = ui_config,
      mappings = {
        ["gf"] = mappings.gf_passthrough(),
        ["<leader>ch"] = mappings.toggle_checkbox(),
        ["<cr>x"] = mappings.smart_action(),
      },
      disable_frontmatter = true,
      follow_url_func = function(url)
        vim.fn.jobstart({ "dotf-open", url })
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "gd", "<Cmd>ObsidianFollowLink<cr>", { buffer = true })

        vim.fn.timer_start(0, function()
          for char, opts in pairs(ui_config.checkboxes) do
            if char ~= " " then
              vim.fn.matchadd(opts.hl_group, "\\[" .. char .. "\\].*$")
            end
          end
        end)
      end,
    })
  end,
  -- keys = {
  --   {
  --     "<Leader>jn",
  --     "<Cmd>ObsidianQuickSwitch<cr>",
  --     mode = "n",
  --   },
  -- },
  -- cmd = { "ObsidianQuickSwitch" },
}
