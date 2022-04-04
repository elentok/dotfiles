local util = require("elentok/util")

local treesitter_configs = util.safe_require("nvim-treesitter.configs")
if not treesitter_configs then
  return
end

local gps = util.safe_require("nvim-gps")
if not gps then
  return
end

gps.setup({})

treesitter_configs.setup {
  ensure_installed = {
    "bash",
    "c",
    "c_sharp",
    "cmake",
    "comment",
    "cpp",
    "css",
    "dot",
    "go",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "lua",
    "python",
    "regex",
    "rst",
    "ruby",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  },
  highlight = {enable = true},
  autopairs = {enable = true},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  -- disable python and typescript indentation until fixed:
  --   https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issue-853914044
  indent = {enable = true, disable = {"python", "typescript", "javascript"}},
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
        ["ic"] = "@class.inner"
      }
    },
    swap = {
      enable = true,
      swap_next = {["<leader>a"] = "@parameter.inner"},
      swap_previous = {["<leader>A"] = "@parameter.inner"}
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {["]]"] = "@function.outer"},
      goto_previous_start = {["[["] = "@function.outer"}
    }
  }
}

local exclude_from_folding = {markdown = true}

function _G.TreesitterSetupFolding()
  local filetype = util.buf_get_filetype(0)
  if exclude_from_folding[filetype] then
    return
  end

  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end

util.augroup("Treesitter", [[
  autocmd FileType * lua TreesitterSetupFolding()
]])
