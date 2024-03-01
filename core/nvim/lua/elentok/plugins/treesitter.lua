local ensure_installed = {
  "bash",
  "c",
  "cmake",
  "comment",
  "cpp",
  "css",
  "dot",
  "fish",
  "go",
  "graphql",
  "hcl", -- terraform
  "html",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "lua",
  -- These are causing Neovim to crash in some specific scenarios,
  -- not sure why.
  -- "markdown",
  -- "markdown_inline",
  "python",
  "regex",
  "rst",
  "ruby",
  "scss",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,

    config = function()
      local treesitter_configs = require("nvim-treesitter.configs")

      treesitter_configs.setup({
        -- additional_vim_regex_highlighting = true,
        playground = {
          enable = true,
        },
        ensure_installed = ensure_installed,
        highlight = { enable = true, disable = { "markdown", "markdown_inline" } },
        autopairs = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        -- disable python and typescript indentation until fixed:
        --   https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issue-853914044
        indent = {
          enable = true,
          disable = { "python", "typescript", "javascript" },
        },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = { ["]]"] = "@function.outer" },
            goto_previous_start = { ["[["] = "@function.outer" },
          },
        },
      })
    end,
  },
  "nvim-treesitter/playground",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "19a91a38b02c1c28c14e0ba468d20ae1423c39b2",
  },
}
