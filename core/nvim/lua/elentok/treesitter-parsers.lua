---@type string[]
local parsers = {
  "bash",
  "c",
  "comment",
  "css",
  "diff",
  "fish",
  "git_config",
  "gitcommit",
  "go",
  "gomod",
  "graphql",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

require("nvim-treesitter").uninstall("all"):wait(300000)
require("nvim-treesitter").install(parsers):wait(300000)
