local util = require("elentok/util")

local has_treesitter, treesitter_configs = pcall(require, "nvim-treesitter.configs")
local has_gps, gps = pcall(require, "nvim-gps")

if not (has_treesitter and has_gps) then
  return
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

gps.setup({})

-- Install markdown parser
parser_configs.markdown = {
  install_info = {
    url = "https://github.com/MDeiml/tree-sitter-markdown",
    location = "tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
  filetype = "markdown",
}

treesitter_configs.setup({
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
    "markdown",
    "python",
    "regex",
    "rst",
    "ruby",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = { enable = true },
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

local exclude_from_folding = {}
-- local exclude_from_folding = { markdown = true }

local function setupFolding()
  local filetype = util.buf_get_filetype(0)
  if exclude_from_folding[filetype] then
    return
  end

  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end

local group_id = vim.api.nvim_create_augroup("Elentok_Treesitter", {})
vim.api.nvim_create_autocmd(
  { "FileType" },
  { pattern = "*", group = group_id, callback = setupFolding }
)
