require'nvim-treesitter.configs'.setup({
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "c", "comment", "css", "diff", "dockerfile",
  "dot", "git_rebase", "gitcommit", "gitignore", "go", "help", "html", "java",
  "javascript", "jsdoc", "json", "lua", "make", "proto", "python", "rust",
  "scss", "tsx", "typescript", "vim", "yaml"},
})
