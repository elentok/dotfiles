local filetypes = {
  "bash",
  "css",
  "diff",
  "dockerfile",
  "fish",
  "gitconfig",
  "gitcommit",
  "go",
  "gomod",
  "graphql",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "python",
  "toml",
  "typescript",
  "typescriptreact",
  "xml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
}
